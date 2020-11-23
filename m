Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333B92C0331
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 11:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKWKY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 05:24:57 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40237 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgKWKY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 05:24:56 -0500
Received: by mail-lj1-f196.google.com with SMTP id y10so1922615ljc.7;
        Mon, 23 Nov 2020 02:24:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nLzASMogujWGHnxanDIbXGOwPXzPxHu1wp2tIpWZ+rY=;
        b=pV9IVeenhb3XcHX5SmmqLrDEesA34ABkNSqb6D78Zb2lJkNp73YrsXkTpcp1MRaAp2
         jsc4318QBxZijOZng2KR9sBXGCAA8ewbFYn8j30Hpv2oMCexjUCh08wPqCAZuFocStJT
         WaRVZYwHofBm2JWdDbguVEdccZ3OqSPSi7Tk7T+a7qq8vD+wSSfLDJhOz1iIeLTtKPdZ
         hjeNHc72Wv7gZcz8BjekDfAntMTxqdz6IZGD8tToJyHX4VqCXIVS6wG1JCYHZ6UFeTMZ
         E8E0Ntrx1TF7LmxjAQ7wkeCe3AKsw0AMZ2vsxwM0vmGtL1e/ehAOyqHlhD3Q61lPQKA6
         PaQg==
X-Gm-Message-State: AOAM5322xm4CgTz+y49i4y4yEyyFdhwe/GA1eiRXKMSChRSUlzFLx71L
        kXDN7cfe7J3qXmRC1beKjj3cmbNivvFIUg==
X-Google-Smtp-Source: ABdhPJyYDhPRmS+pUDfJXySNGbs8u+iD3A5Rxn1MCVE9KIYVyiRPbjl8qTUPb035OfDFqbthhcQK0w==
X-Received: by 2002:a2e:7a0a:: with SMTP id v10mr13327749ljc.5.1606127094045;
        Mon, 23 Nov 2020 02:24:54 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id n6sm429919lfi.106.2020.11.23.02.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 02:24:52 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kh91q-00027m-4N; Mon, 23 Nov 2020 11:25:02 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Frank Rowand <frowand.list@gmail.com>,
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
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2 1/8] of: fix linker-section match-table corruption
Date:   Mon, 23 Nov 2020 11:23:12 +0100
Message-Id: <20201123102319.8090-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201123102319.8090-1-johan@kernel.org>
References: <20201123102319.8090-1-johan@kernel.org>
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
entry. Specifying alignment when declaring variables suppresses this
optimisation.

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

