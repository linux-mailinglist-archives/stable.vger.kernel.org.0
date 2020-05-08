Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917B21CAB05
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgEHMjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbgEHMjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BE0C2495C;
        Fri,  8 May 2020 12:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941543;
        bh=rD0tM0T/ftxZrkaotABuMcnQ1GNy2NIDdRHJ9oET2X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymjF86ZHvYgIIDrA+qdlNzOfQ9alv6lyuw29PAmzhT7sCFV2C9IIMrUoIAHQY9QM6
         Nzh7LSgzg7iLE166m/8hRz0I5cL9MBEJ6+HJuG/SdnLN0UIC61PWj60YPajRZPntga
         c79TdATw89TFdUTmxkMuP9N7iNKHqbEWu6HqSuAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Noa Osherovich <noaos@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 4.4 075/312] IB/mlx5: Fix FW version diaplay in sysfs
Date:   Fri,  8 May 2020 14:31:06 +0200
Message-Id: <20200508123129.806138083@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

commit c0fcebf55289c48148992eee002a7caf853a5358 upstream.

Add a 4-digit padding to show FW version in proper format.

Fixes: 9603b61de1eee ('mlx5: Move pci device handling from...')
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Noa Osherovich <noaos@mellanox.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -905,7 +905,7 @@ static ssize_t show_fw_ver(struct device
 {
 	struct mlx5_ib_dev *dev =
 		container_of(device, struct mlx5_ib_dev, ib_dev.dev);
-	return sprintf(buf, "%d.%d.%d\n", fw_rev_maj(dev->mdev),
+	return sprintf(buf, "%d.%d.%04d\n", fw_rev_maj(dev->mdev),
 		       fw_rev_min(dev->mdev), fw_rev_sub(dev->mdev));
 }
 


