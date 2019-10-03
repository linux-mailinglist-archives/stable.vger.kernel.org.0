Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54350CAC8D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387978AbfJCQMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387990AbfJCQMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:12:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67C3B20700;
        Thu,  3 Oct 2019 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119133;
        bh=a+KhuUV2OOAQsa6Eu69UYdgnsSiU9l/+U5sClBKGbLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dnmzro4gf/SLmsuFfZ4HVKDW0otVz92jAtborxuZo+hHCr7pzbfAtLNeyDoEE1n4s
         u6MbLID+9kZDXpHYufnNYjPLBAo5DW+pZcd/6DCbeyMptgPJpt3GvdsdblMjdQLWBy
         +mHxGJsSnLAXvXrYhT3R4oFcJzMWChLI05Hao3Uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 139/185] PM / devfreq: passive: fix compiler warning
Date:   Thu,  3 Oct 2019 17:53:37 +0200
Message-Id: <20191003154508.965694616@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: MyungJoo Ham <myungjoo.ham@samsung.com>

[ Upstream commit 0465814831a926ce2f83e8f606d067d86745234e ]

The recent commit of
PM / devfreq: passive: Use non-devm notifiers
had incurred compiler warning, "unused variable 'dev'".

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/governor_passive.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/devfreq/governor_passive.c b/drivers/devfreq/governor_passive.c
index 4222d3c1efb98..d2ebdb7fd7518 100644
--- a/drivers/devfreq/governor_passive.c
+++ b/drivers/devfreq/governor_passive.c
@@ -152,7 +152,6 @@ static int devfreq_passive_notifier_call(struct notifier_block *nb,
 static int devfreq_passive_event_handler(struct devfreq *devfreq,
 				unsigned int event, void *data)
 {
-	struct device *dev = devfreq->dev.parent;
 	struct devfreq_passive_data *p_data
 			= (struct devfreq_passive_data *)devfreq->data;
 	struct devfreq *parent = (struct devfreq *)p_data->parent;
-- 
2.20.1



