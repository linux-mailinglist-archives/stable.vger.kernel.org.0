Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94BAEE680E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbfJ0VZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731794AbfJ0VZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:51 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C011121850;
        Sun, 27 Oct 2019 21:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211551;
        bh=Tm4BdJN9ne3+ntdGFp4Y+4aAsgJ97NXwx5V7GJ7chI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Op+8Kh7EXJQc92IJOpQhd60ZfkJeKHvnmOYmoK4pBknFdMkrazeQfbH+UITOrOI8T
         XMPz1QzdeomLr8kFdYZm+AAp6MgzQoCZoAxs8Be+hP/mCNkyS8yQIEP0oUw9edl+Cl
         laN62rHa2IfQPXam5Pg5WG7zKJ3OmXzZYAGjZP5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Paul Durrant <paul@xen.org>, Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 192/197] xen/netback: fix error path of xenvif_connect_data()
Date:   Sun, 27 Oct 2019 22:01:50 +0100
Message-Id: <20191027203406.850717453@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 3d5c1a037d37392a6859afbde49be5ba6a70a6b3 upstream.

xenvif_connect_data() calls module_put() in case of error. This is
wrong as there is no related module_get().

Remove the superfluous module_put().

Fixes: 279f438e36c0a7 ("xen-netback: Don't destroy the netdev until the vif is shut down")
Cc: <stable@vger.kernel.org> # 3.12
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netback/interface.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -719,7 +719,6 @@ err_unmap:
 	xenvif_unmap_frontend_data_rings(queue);
 	netif_napi_del(&queue->napi);
 err:
-	module_put(THIS_MODULE);
 	return err;
 }
 


