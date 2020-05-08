Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416681CAF63
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgEHMn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729116AbgEHMnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B00CF20720;
        Fri,  8 May 2020 12:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941835;
        bh=yGfNa+n5Nyg6FPVOOg9qf7jiROMVkZog5tzowtrAA5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fVqGiaCDbdAeHADlfS1YqVmqy8MjhY3qvmxrYGHGGIon9gtEC9Qs3dfKugwBIKf4
         lDM+HODyFf4xCfjDkkBhCRwO3O3ULZhQrS5KH9Gs3vTMp/XBa8LbiB8g7hkuLpPoOS
         yxgW72hidAK3bYzGIkErAFJ+PMas4H4qPOUGOKCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Ricard <christophe-h.ricard@st.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4.4 151/312] NFC: nci: memory leak in nci_core_conn_create()
Date:   Fri,  8 May 2020 14:32:22 +0200
Message-Id: <20200508123135.083649102@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c6dc65d885b98898bf287aaf44e020077b41769f upstream.

I've moved the check for "number_destination_params" forward
a few lines to avoid leaking "cmd".

Fixes: caa575a86ec1 ('NFC: nci: fix possible crash in nci_core_conn_create')

Acked-by: Christophe Ricard <christophe-h.ricard@st.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/nci/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -610,14 +610,14 @@ int nci_core_conn_create(struct nci_dev
 	struct nci_core_conn_create_cmd *cmd;
 	struct core_conn_create_data data;
 
+	if (!number_destination_params)
+		return -EINVAL;
+
 	data.length = params_len + sizeof(struct nci_core_conn_create_cmd);
 	cmd = kzalloc(data.length, GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
-	if (!number_destination_params)
-		return -EINVAL;
-
 	cmd->destination_type = destination_type;
 	cmd->number_destination_params = number_destination_params;
 	memcpy(cmd->params, params, params_len);


