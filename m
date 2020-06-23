Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26188206636
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388145AbgFWVjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388169AbgFWUHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:07:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E3B320EDD;
        Tue, 23 Jun 2020 20:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942851;
        bh=6/dQmFsaYiZudDlU15aTEKI+ILQi1VWmGyK/oRBAY90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ke37qeNduM96bhk0sSh2mHXMb93OuYJh6JQ3ItDa7Kfv/OUZmZ6jEN+PjMOURZkTn
         BCJxv8B/uNsOC7fY5f2QL+3Pxlqt1j25X9rR4JsMcQcsBL2Zpvw2khhpVLVG+dKUXx
         FL6qeZDDlMiBYHm0OkT9VvVvC279GIEc7u/0aLFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 160/477] soundwire: slave: dont init debugfs on device registration error
Date:   Tue, 23 Jun 2020 21:52:37 +0200
Message-Id: <20200623195415.163746051@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 8893ab5e8ee5d7c12e0fc1dca4a309475064473d ]

The error handling flow seems incorrect, there is no reason to try and
add debugfs support if the device registration did not
succeed. Return on error.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Link: https://lore.kernel.org/r/20200419185117.4233-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/slave.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index aace57fae7f83..4bacdb187eab8 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -68,6 +68,8 @@ static int sdw_slave_add(struct sdw_bus *bus,
 		list_del(&slave->node);
 		mutex_unlock(&bus->bus_lock);
 		put_device(&slave->dev);
+
+		return ret;
 	}
 	sdw_slave_debugfs_init(slave);
 
-- 
2.25.1



