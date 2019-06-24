Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393AD507CA
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfFXKKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730063AbfFXKIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:08:23 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AADD2063F;
        Mon, 24 Jun 2019 10:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370903;
        bh=S5Ih/cw815bVGp1ee991/jgGq5ib6H35gmUvCouQTgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMlmajK6jcTOEQWZpijbabRzAGJ1Z34PPfbx23dTJPLLY+LHREPn6pJwlUtNIqKEv
         xFxxMIwsqdOtBah+o9s2euDEFCYF4uEzyTIpdnVHxi132TpEZ/Ii43l65RUNb/bA72
         NDaFzMKMDJGI7sOKhljZco5WV5YWgFt7r1picObA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        linux-fpga@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 044/121] fpga: stratix10-soc: fix use-after-free on s10_init()
Date:   Mon, 24 Jun 2019 17:56:16 +0800
Message-Id: <20190624092323.034944246@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f5dd87326fefe42a4b1a4b1a1a695060c33a88d6 ]

The refcount of fw_np has already been decreased by of_find_matching_node()
so it shouldn't be used anymore.
This patch adds an of_node_get() before of_find_matching_node() to avoid
the use-after-free problem.

Fixes: e7eef1d7633a ("fpga: add intel stratix10 soc fpga manager driver")
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc: linux-fpga@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Moritz Fischer <mdf@kernel.org>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Acked-by: Alan Tull <atull@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/stratix10-soc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/stratix10-soc.c b/drivers/fpga/stratix10-soc.c
index 13851b3d1c56..215d33789c74 100644
--- a/drivers/fpga/stratix10-soc.c
+++ b/drivers/fpga/stratix10-soc.c
@@ -507,12 +507,16 @@ static int __init s10_init(void)
 	if (!fw_np)
 		return -ENODEV;
 
+	of_node_get(fw_np);
 	np = of_find_matching_node(fw_np, s10_of_match);
-	if (!np)
+	if (!np) {
+		of_node_put(fw_np);
 		return -ENODEV;
+	}
 
 	of_node_put(np);
 	ret = of_platform_populate(fw_np, s10_of_match, NULL, NULL);
+	of_node_put(fw_np);
 	if (ret)
 		return ret;
 
-- 
2.20.1



