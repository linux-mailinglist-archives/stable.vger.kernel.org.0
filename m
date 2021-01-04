Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB85D2E92C4
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 10:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbhADJqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 04:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADJqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 04:46:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD4BE206F0;
        Mon,  4 Jan 2021 09:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609753525;
        bh=YdA91+8BC4gWTfSwrFSJeds0Z/p2l1G9dwtb9jyjoFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePtol1a7GMtDL8rjz+7DHzbIi6dH6AAqiNRakPrPLewrPJBq2bRREBvgeuxlpKnhj
         /KQiWA/U04dtbczkqbL1bIEkEgB5loZWHfX+e0p4bqdyRb6SFY+U5Rlq/82tyXhq4N
         MfPYpovqZFoczx1AFYTf6oio578YYwfNw3BU+aXLbpJt0hEDusyB4PyWsEgYIXGWMX
         IRkDz0XVZV12Tu2aLKDgPlbOAvzVaLDHhzQCJryWSLGD7gnxQF7EJeebeEh+Z8Wxvk
         bvR+XmKdZKWdage3rXYI22AmEw4TZtYKJJZAYgtIZWtf/S1cBOgip+EZM39sSFw/Yp
         xvZkHw8hFPj9g==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kwMQT-0004vz-VT; Mon, 04 Jan 2021 10:45:22 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH stable-5.4] of: fix linker-section match-table corruption
Date:   Mon,  4 Jan 2021 10:44:35 +0100
Message-Id: <20210104094435.18916-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1609156019944@kroah.com>
References: <1609156019944@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5812b32e01c6d86ba7a84110702b46d8a8531fe9 upstream.

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
Link: https://lore.kernel.org/r/20201123102319.8090-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ johan: adjust context to 5.4 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---

Greg and Sasha, this one should hopefully apply to all stable trees
which doesn't have 33def8498fdd ("treewide: Convert macro and uses of
__section(foo) to __section("foo")").

Johan


 include/linux/of.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 844f89e1b039..a7621e2b440a 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1282,6 +1282,7 @@ static inline int of_get_available_child_count(const struct device_node *np)
 #define _OF_DECLARE(table, name, compat, fn, fn_type)			\
 	static const struct of_device_id __of_table_##name		\
 		__used __section(__##table##_of_table)			\
+		__aligned(__alignof__(struct of_device_id))		\
 		 = { .compatible = compat,				\
 		     .data = (fn == (fn_type)NULL) ? fn : fn  }
 #else
-- 
2.26.2

