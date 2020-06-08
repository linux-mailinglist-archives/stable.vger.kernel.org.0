Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FB81F2D07
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbgFHXPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730103AbgFHXPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1767220760;
        Mon,  8 Jun 2020 23:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658149;
        bh=T91HkriA4AVveN5p0X9Tth1A4tfYSz0CPkwXMfu++hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5gly1zXRiK8L3Dx9iKRSudRrr5sELbF7AYVwWuhI732n5GAsrvYW/PLyh6IXX5TX
         6Q1omBG3q5K15Xjs+/Ht8f7Aw+NDXCkgI4OLvCUGtd3KnQdZJAKOHt1OFjcx9r/teK
         9DQlhh0cXZ64NpbR7srWM4RWNMtZgh1fqwTKMVCw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        =?UTF-8?q?=E4=BA=BF=E4=B8=80?= <teroincn@gmail.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 5.6 182/606] mei: release me_cl object reference
Date:   Mon,  8 Jun 2020 19:05:07 -0400
Message-Id: <20200608231211.3363633-182-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/misc/mei/client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 1e3edbbacb1e..c6b163060c76 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -266,6 +266,7 @@ void mei_me_cl_rm_by_uuid(struct mei_device *dev, const uuid_le *uuid)
 	down_write(&dev->me_clients_rwsem);
 	me_cl = __mei_me_cl_by_uuid(dev, uuid);
 	__mei_me_cl_del(dev, me_cl);
+	mei_me_cl_put(me_cl);
 	up_write(&dev->me_clients_rwsem);
 }
 
@@ -287,6 +288,7 @@ void mei_me_cl_rm_by_uuid_id(struct mei_device *dev, const uuid_le *uuid, u8 id)
 	down_write(&dev->me_clients_rwsem);
 	me_cl = __mei_me_cl_by_uuid_id(dev, uuid, id);
 	__mei_me_cl_del(dev, me_cl);
+	mei_me_cl_put(me_cl);
 	up_write(&dev->me_clients_rwsem);
 }
 
-- 
2.25.1

