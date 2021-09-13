Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F6C4095CF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345350AbhIMOpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347643AbhIMOmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D848A613AD;
        Mon, 13 Sep 2021 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541394;
        bh=juVvDDcx7uKX4Wmg4I3lE4WfnfHtsvvq20vFOONIH5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhol+1gRPCU1tqSzQ4RP9L7CbirHfi7uU3rjA1w6o748tZcrUbXWr9EJ0gRQoAoH/
         dfaaIjdnFqMaYUsnIEdHUX+MtHXKP0p9LHyhvGuNYzED26FeebKucF1eUTk0f4UrP1
         h9MaRaiZru9eilr7ciJg7EqfMyfPeUrRYka3nhqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 273/334] misc/pvpanic: fix set driver data
Date:   Mon, 13 Sep 2021 15:15:27 +0200
Message-Id: <20210913131122.650214174@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mihai Carabas <mihai.carabas@oracle.com>

[ Upstream commit a99009bc4f2f0b46e6c553704fda0b67e04395f5 ]

Add again dev_set_drvdata(), but this time in devm_pvpanic_probe(), in order
for dev_get_drvdata() to not return NULL.

Fixes: 394febc9d0a6 ("misc/pvpanic: Make 'pvpanic_probe()' resource managed")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Link: https://lore.kernel.org/r/1629385946-4584-2-git-send-email-mihai.carabas@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index 02b807c788c9..bb7aa6368538 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -85,6 +85,8 @@ int devm_pvpanic_probe(struct device *dev, struct pvpanic_instance *pi)
 	list_add(&pi->list, &pvpanic_list);
 	spin_unlock(&pvpanic_lock);
 
+	dev_set_drvdata(dev, pi);
+
 	return devm_add_action_or_reset(dev, pvpanic_remove, pi);
 }
 EXPORT_SYMBOL_GPL(devm_pvpanic_probe);
-- 
2.30.2



