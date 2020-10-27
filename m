Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764C729B5FF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796466AbgJ0PSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796464AbgJ0PSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:18:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 938CF20657;
        Tue, 27 Oct 2020 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811929;
        bh=pFs9n+Gj1jKW2bBBP7YnwJ58RyLikOVqgifg89QbknU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EvpfgOZAfQKsErvykPWIj1XzA6k1qyGHDaEDFqnYR1oW2o7fE2vVvJLHdlD2NNmc
         gfxsQ3Rw5wv3R2Zai9muYVitrcN/jvDvDp0ihqZRzHvDE/osalR3IY64bo8k9YcBc7
         fcT5dq3Of5TMxVOOhkIvGADcuTAI8JTAQ7azclug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Venkatesh Ellapu <venkatesh.e@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 032/757] chelsio/chtls: correct netdevice for vlan interface
Date:   Tue, 27 Oct 2020 14:44:42 +0100
Message-Id: <20201027135452.029850864@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
@@ -1157,6 +1157,9 @@ static struct sock *chtls_recv_sock(stru
 	ndev = n->dev;
 	if (!ndev)
 		goto free_dst;
+	if (is_vlan_dev(ndev))
+		ndev = vlan_dev_real_dev(ndev);
+
 	port_id = cxgb4_port_idx(ndev);
 
 	csk = chtls_sock_create(cdev);


