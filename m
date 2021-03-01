Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81F2328379
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbhCAQTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:19:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237760AbhCAQSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:18:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E24964E68;
        Mon,  1 Mar 2021 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615416;
        bh=IQgM5rHpzF8bXacyR4utFjbSAQtRXCQsH0HVHltG6oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrafuLPCe6kmAHSdC1pxsYcW4/UvNuoVd+1YNJs6W73x3SxD5zAGyBEn3K3UAT4Vs
         52khWw4vet4qky5M31O7HKHPS+m/nG9rxW7ymszfC6eevekUReAutqU8/uv/OmTR/2
         FbWB7JEuUtB4tM6alyg3kRVFf1sWlMAaSoxoEmWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.com>,
        Markus Boehme <markubo@amazon.de>
Subject: [PATCH 4.4 03/93] xen-netback: delete NAPI instance when queue fails to initialize
Date:   Mon,  1 Mar 2021 17:12:15 +0100
Message-Id: <20210301161007.049917293@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

commit 4a658527271bce43afb1cf4feec89afe6716ca59 upstream.

When xenvif_connect() fails it may leave a stale NAPI instance added to
the device.  Make sure we delete it in the error path.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: SeongJae Park <sjpark@amazon.com>
Tested-by: Markus Boehme <markubo@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/interface.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -662,6 +662,7 @@ err_tx_unbind:
 	queue->tx_irq = 0;
 err_unmap:
 	xenvif_unmap_frontend_rings(queue);
+	netif_napi_del(&queue->napi);
 err:
 	return err;
 }


