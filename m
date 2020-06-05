Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3001EFB5E
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgFEO0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbgFEOPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:15:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399AB20820;
        Fri,  5 Jun 2020 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366546;
        bh=kFwCRCraMBRyepMZo+yl/SXXPj0zsoJ7YQUxEPQ2XHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gL6vX6s9SztLWVmhMJxWvGMHBA96b9dSBEqD7QoI2oF8Aa1JQh0xnzQX/WcHBJVpB
         zvj4RvVKhIT3dv642oEo3GkQvoBYDSTYc4Zupf0iR609YullXu27WthbQZMX5PLcun
         2txakzkliTESaZJJzbJiFouFng/CTAklH/RfAvOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.7 10/14] mmc: fix compilation of user API
Date:   Fri,  5 Jun 2020 16:15:00 +0200
Message-Id: <20200605135951.634456292@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605135951.018731965@linuxfoundation.org>
References: <20200605135951.018731965@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

commit 83fc5dd57f86c3ec7d6d22565a6ff6c948853b64 upstream.

The definitions of MMC_IOC_CMD  and of MMC_IOC_MULTI_CMD rely on
MMC_BLOCK_MAJOR:

    #define MMC_IOC_CMD       _IOWR(MMC_BLOCK_MAJOR, 0, struct mmc_ioc_cmd)
    #define MMC_IOC_MULTI_CMD _IOWR(MMC_BLOCK_MAJOR, 1, struct mmc_ioc_multi_cmd)

However, MMC_BLOCK_MAJOR is defined in linux/major.h and
linux/mmc/ioctl.h did not include it.

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200511161902.191405-1-Jerome.Pouiller@silabs.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/mmc/ioctl.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/linux/mmc/ioctl.h
+++ b/include/uapi/linux/mmc/ioctl.h
@@ -3,6 +3,7 @@
 #define LINUX_MMC_IOCTL_H
 
 #include <linux/types.h>
+#include <linux/major.h>
 
 struct mmc_ioc_cmd {
 	/*


