Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC0C32E95B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhCEMcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232391AbhCEMbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:31:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8678B6501A;
        Fri,  5 Mar 2021 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947512;
        bh=qzNk5X6xgehnTTSaKN14gqSi84lgVKwUioRVFwG1aS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDWbqnEG27z9O08HiQfMyfysVsUKMa5nYm0IW+RBELwbztOG3U0mfKnucdsaN5IGw
         V7pzWG5mZo7gT6wz/BDEPMYqYQnPw4TIZxxOASzjlRj/Ca5Ce8JwtC1tmQsNIReX/o
         UzGIvbGYybvnD+dcQaDz4khFvQ9KmYdUPQBc+Zew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH 5.10 090/102] remoteproc/mediatek: Fix kernel test robot warning
Date:   Fri,  5 Mar 2021 13:21:49 +0100
Message-Id: <20210305120907.706766212@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

commit cca21000261b2364991ecdb0d9e66b26ad9c4b4e upstream.

Kernel test robot throws below warning ->

>> drivers/remoteproc/mtk_scp.c:755:37: warning: unused variable
>> 'mt8183_of_data' [-Wunused-const-variable]
   static const struct mtk_scp_of_data mt8183_of_data = {
                                       ^
>> drivers/remoteproc/mtk_scp.c:765:37: warning: unused variable
>> 'mt8192_of_data' [-Wunused-const-variable]
   static const struct mtk_scp_of_data mt8192_of_data = {
                                       ^
As suggested by Bjorn, there's no harm in just dropping the
of_match_ptr() wrapping of mtk_scp_of_match in the definition of
mtk_scp_driver and we avoid this whole problem.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Link: https://lore.kernel.org/r/1606513855-21130-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/mtk_scp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -775,21 +775,19 @@ static const struct mtk_scp_of_data mt81
 	.host_to_scp_int_bit = MT8192_HOST_IPC_INT_BIT,
 };
 
-#if defined(CONFIG_OF)
 static const struct of_device_id mtk_scp_of_match[] = {
 	{ .compatible = "mediatek,mt8183-scp", .data = &mt8183_of_data },
 	{ .compatible = "mediatek,mt8192-scp", .data = &mt8192_of_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, mtk_scp_of_match);
-#endif
 
 static struct platform_driver mtk_scp_driver = {
 	.probe = scp_probe,
 	.remove = scp_remove,
 	.driver = {
 		.name = "mtk-scp",
-		.of_match_table = of_match_ptr(mtk_scp_of_match),
+		.of_match_table = mtk_scp_of_match,
 	},
 };
 


