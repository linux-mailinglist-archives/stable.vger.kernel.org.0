Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C7629B368
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766490AbgJ0OtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766474AbgJ0Os5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:48:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E7021556;
        Tue, 27 Oct 2020 14:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810137;
        bh=oCyaB5rQ2twdVYoEcV2VUtmuv04B0TrK2chOv0r8LKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khizTHrmzx1mie5N1VSvFrW2HTOkF9VHTyEGIc3KBXg+YKhIBlGwra+HMMuMn73Jc
         wRVJJ8tKNabpsnOEfwkliEa0BSrr3jCXoOAk3YNOQX6YDqyZtRdmyBGHkCqGKIhSGu
         YgEPw0zB4tgLXSvFSXtFVen4BCqyZz12x1OZtrLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Venkatesh Ellapu <venkatesh.e@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 033/633] chelsio/chtls: correct netdevice for vlan interface
Date:   Tue, 27 Oct 2020 14:46:16 +0100
Message-Id: <20201027135524.251439419@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 81519d1f7df7ed1bd5b1397540c8884438f57ae2 ]

Check if netdevice is a vlan interface and find real vlan netdevice.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Venkatesh Ellapu <venkatesh.e@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1156,6 +1156,9 @@ static struct sock *chtls_recv_sock(stru
 	ndev = n->dev;
 	if (!ndev)
 		goto free_dst;
+	if (is_vlan_dev(ndev))
+		ndev = vlan_dev_real_dev(ndev);
+
 	port_id = cxgb4_port_idx(ndev);
 
 	csk = chtls_sock_create(cdev);


