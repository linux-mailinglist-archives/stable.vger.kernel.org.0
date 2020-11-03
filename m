Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F372A4E05
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 19:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgKCSMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 13:12:25 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39602 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbgKCSME (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 13:12:04 -0500
Received: by mail-lj1-f194.google.com with SMTP id m16so20086894ljo.6;
        Tue, 03 Nov 2020 10:12:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=76fujNvmaDU5izlocC2iDYMlwXY99PLp9hN2X9PjG0k=;
        b=SBohuV1MmKS50OO3v6YK9Sk7/tOFIho5ZZISZHogAe7B0oWR+MwU9Prb0J1dzZlRs/
         f7dnPjikh2cu/er94c4HKfCSuJj/sLK0egl76EtIrmZIDDbaD1pfwZSu+ikMLBuAk409
         d71+sOMChWpCw6hFfktJEGQPH6L1Fuk20DpPdwOTWFKP2G/B4ex5hp+po1sqGS7w8IH8
         WaVAenyH+BVCTDzu7x0qbwYtkjIsACXyXRopr4X4kcy//q3pz33nUoWbOPT71Dk3S66j
         e36A+B2iu5zM9R9nM3rmw2QrKHX56SuUhD9OEJRBlaAc3BBEPWdt1z0E1E9kGp1PGeT3
         sBJQ==
X-Gm-Message-State: AOAM531B8Nq2TSTnS5Vj1etW6RKMCRwL0a/UYBzoJkkn7EX5GzvYQ4JX
        NiNVwAwsmC1tx707fPQRfk5357lhwrWfgA==
X-Google-Smtp-Source: ABdhPJw6rQq0Fh3kcxIva7KSE+qsd1+5egDz952MKuJgRAuL68zhNMHWuZwjaNwDpdN2HgxJoFCTxQ==
X-Received: by 2002:a2e:7617:: with SMTP id r23mr9525714ljc.0.1604427120842;
        Tue, 03 Nov 2020 10:12:00 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id a25sm3688646lfo.141.2020.11.03.10.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 10:11:59 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1ka0mn-0002rR-Jv; Tue, 03 Nov 2020 19:12:01 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jessica Yu <jeyu@kernel.org>,
        Nick Desaulniers <ndesaulniers@gooogle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        linux-arch@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/8] of: fix linker-section match-table corruption
Date:   Tue,  3 Nov 2020 18:57:04 +0100
Message-Id: <20201103175711.10731-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103175711.10731-1-johan@kernel.org>
References: <20201103175711.10731-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Specify type alignment when declaring linker-section match-table entries
to prevent gcc from increasing alignment and corrupting the various
tables with padding (e.g. timers, irqchips, clocks, reserved memory).

This is specifically needed on x86 where gcc (typically) aligns larger
objects like struct of_device_id with static extent on 32-byte
boundaries which at best prevents matching on anything but the first
entry.

Here's a 64-bit example where all entries are corrupt as 16 bytes of
padding has been inserted before the first entry:

	ffffffff8266b4b0 D __clk_of_table
	ffffffff8266b4c0 d __of_table_fixed_factor_clk
	ffffffff8266b5a0 d __of_table_fixed_clk
	ffffffff8266b680 d __clk_of_table_sentinel

And here's a 32-bit example where the 8-byte-aligned table happens to be
placed on a 32-byte boundary so that all but the first entry are corrupt
due to the 28 bytes of padding inserted between entries:

	812b3ec0 D __irqchip_of_table
	812b3ec0 d __of_table_irqchip1
	812b3fa0 d __of_table_irqchip2
	812b4080 d __of_table_irqchip3
	812b4160 d irqchip_of_match_end

Verified on x86 using gcc-9.3 and gcc-4.9 (which uses 64-byte
alignment), and on arm using gcc-7.2.

Note that there are no in-tree users of these tables on x86 currently
(even if they are included in the image).

Fixes: 54196ccbe0ba ("of: consolidate linker section OF match table declarations")
Fixes: f6e916b82022 ("irqchip: add basic infrastructure")
Cc: stable <stable@vger.kernel.org>     # 3.9
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 include/linux/of.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 5d51891cbf1a..af655d264f10 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1300,6 +1300,7 @@ static inline int of_get_available_child_count(const struct device_node *np)
 #define _OF_DECLARE(table, name, compat, fn, fn_type)			\
 	static const struct of_device_id __of_table_##name		\
 		__used __section("__" #table "_of_table")		\
+		__aligned(__alignof__(struct of_device_id))		\
 		 = { .compatible = compat,				\
 		     .data = (fn == (fn_type)NULL) ? fn : fn  }
 #else
-- 
2.26.2

