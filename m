Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315B41CAFFB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgEHNWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgEHMjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3DBE24980;
        Fri,  8 May 2020 12:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941541;
        bh=l1C9s7CPMjwj1RAowoPqQFLmKe6QrHwZ7hsFWx6YITg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc+Q8ZbCf6kWtgXTGBXK/wnvN6VQDq/hBFBhsHMWdp1IlrQgUUUGA1wh2knfsHJOA
         zm+M+ty1UrAbwA0mVhoOBuWdoQlnW+huVGycgAky+OeEfKYXy4BuhpkzmF7HWLg7wP
         qs8MQSwm6nbRWo3JpKxRALRelLm3vMN4i/KopSzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 074/312] net/mlx5: Make command timeout way shorter
Date:   Fri,  8 May 2020 14:31:05 +0200
Message-Id: <20200508123129.739466614@linuxfoundation.org>
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

From: Or Gerlitz <ogerlitz@mellanox.com>

commit 6b6c07bdcdc97ccac2596063bfc32a5faddfe884 upstream.

The command timeout is terribly long, whole two hours. Make it 60s so if
things do go wrong, the user gets feedback in relatively short time, so
they can take corrective actions and/or investigate using tools and such.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mlx5/driver.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -54,7 +54,7 @@ enum {
 	/* one minute for the sake of bringup. Generally, commands must always
 	 * complete and we may need to increase this timeout value
 	 */
-	MLX5_CMD_TIMEOUT_MSEC	= 7200 * 1000,
+	MLX5_CMD_TIMEOUT_MSEC	= 60 * 1000,
 	MLX5_CMD_WQ_MAX_NAME	= 32,
 };
 


