Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B575B469C4C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243529AbhLFPVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357261AbhLFPSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:18:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595DDC08EAFD;
        Mon,  6 Dec 2021 07:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB58D61327;
        Mon,  6 Dec 2021 15:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA0CC341C6;
        Mon,  6 Dec 2021 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803513;
        bh=C3rkVKzteW0SpKk25N7VPYRyJsxtohM/s/8STn33ccc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nARIhOBZk7JiEjT5WrSniHnmQ+36EDNf71iZ32vfA5ZFRMw5NznDUmmHaMtOIXLfs
         0c4m9Jp54x/Mi1Ni2mi4kaY1vx40BLOcoreYBDJXU0OaCbPj3Cgf8uuoxkv4ULcN0H
         jkhX8ZuadI8iT1pLNHg0vdyip16wPYWCPGbYwK4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.4 02/70] of: clk: Make <linux/of_clk.h> self-contained
Date:   Mon,  6 Dec 2021 15:56:06 +0100
Message-Id: <20211206145551.994560216@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 5df867145f8adad9e5cdf9d67db1fbc0f71351e9 upstream.

Depending on include order:

    include/linux/of_clk.h:11:45: warning: ‘struct device_node’ declared inside parameter list will not be visible outside of this definition or declaration
     unsigned int of_clk_get_parent_count(struct device_node *np);
						 ^~~~~~~~~~~
    include/linux/of_clk.h:12:43: warning: ‘struct device_node’ declared inside parameter list will not be visible outside of this definition or declaration
     const char *of_clk_get_parent_name(struct device_node *np, int index);
					       ^~~~~~~~~~~
    include/linux/of_clk.h:13:31: warning: ‘struct of_device_id’ declared inside parameter list will not be visible outside of this definition or declaration
     void of_clk_init(const struct of_device_id *matches);
				   ^~~~~~~~~~~~

Fix this by adding forward declarations for struct device_node and
struct of_device_id.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lkml.kernel.org/r/20200205194649.31309-1-geert+renesas@glider.be
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/of_clk.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/of_clk.h
+++ b/include/linux/of_clk.h
@@ -6,6 +6,9 @@
 #ifndef __LINUX_OF_CLK_H
 #define __LINUX_OF_CLK_H
 
+struct device_node;
+struct of_device_id;
+
 #if defined(CONFIG_COMMON_CLK) && defined(CONFIG_OF)
 
 unsigned int of_clk_get_parent_count(struct device_node *np);


