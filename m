Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49E81E2E5F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391047AbgEZTCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389115AbgEZTCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:02:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12F562084C;
        Tue, 26 May 2020 19:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519731;
        bh=bTdwv1vyZUg+549OUWqfF6B+jLil2PTqgnQIUtA4yM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt06jzsiE5ZHU2OE53YfNHj/8QFGzwKFOA70hiJVp/B44X9rGby1ZjaUYkJSiI/Gx
         FhJXztQjOTAC3bA+pvusMcJrLB98MS0MNDIh/T4K6U+XlpOnyC+krp9kjqgqDfCRvD
         yfSsF7zcv7vZNsunzXVWAPW2u29VAmqX4aAJPG0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E4=BA=BF=E4=B8=80?= <teroincn@gmail.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4.14 54/59] mei: release me_cl object reference
Date:   Tue, 26 May 2020 20:53:39 +0200
Message-Id: <20200526183923.460766309@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit fc9c03ce30f79b71807961bfcb42be191af79873 upstream.

Allow me_cl object to be freed by releasing the reference
that was acquired  by one of the search functions:
__mei_me_cl_by_uuid_id() or __mei_me_cl_by_uuid()

Cc: <stable@vger.kernel.org>
Reported-by: 亿一 <teroincn@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20200512223140.32186-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/client.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -276,6 +276,7 @@ void mei_me_cl_rm_by_uuid(struct mei_dev
 	down_write(&dev->me_clients_rwsem);
 	me_cl = __mei_me_cl_by_uuid(dev, uuid);
 	__mei_me_cl_del(dev, me_cl);
+	mei_me_cl_put(me_cl);
 	up_write(&dev->me_clients_rwsem);
 }
 
@@ -297,6 +298,7 @@ void mei_me_cl_rm_by_uuid_id(struct mei_
 	down_write(&dev->me_clients_rwsem);
 	me_cl = __mei_me_cl_by_uuid_id(dev, uuid, id);
 	__mei_me_cl_del(dev, me_cl);
+	mei_me_cl_put(me_cl);
 	up_write(&dev->me_clients_rwsem);
 }
 


