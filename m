Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8141C3C4CB1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242571AbhGLHGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243901AbhGLHF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:05:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7708E6120D;
        Mon, 12 Jul 2021 07:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073365;
        bh=BlGq8KKuCkSpLMk5NR9JZxmkyEyOdfvm0EvyJwhVNFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zYXmeoa8Xrr8wYf+ccD+uFskKQYJvlrJwFylZSTlub+ZjQjAnuyAtYs/Kl5rGV+R
         z2uU1hbiKw+jDM1DLWL92mtTvUDRxbhCdXiA0GZaQNM1bWmjnAFq6qyBSxu+VL4IEx
         Wi3gzwJ922GN4CPSI0eTEy1v+E/7LgmnoK8Pd1fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 175/700] media: siano: fix device register error path
Date:   Mon, 12 Jul 2021 08:04:18 +0200
Message-Id: <20210712060951.102078176@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 5368b1ee2939961a16e74972b69088433fc52195 ]

As reported by smatch:
	drivers/media/common/siano/smsdvb-main.c:1231 smsdvb_hotplug() warn: '&client->entry' not removed from list

If an error occur at the end of the registration logic, it won't
drop the device from the list.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/siano/smsdvb-main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index ae17407e477a..7cc654bc52d3 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1176,6 +1176,10 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	return 0;
 
 media_graph_error:
+	mutex_lock(&g_smsdvb_clientslock);
+	list_del(&client->entry);
+	mutex_unlock(&g_smsdvb_clientslock);
+
 	smsdvb_debugfs_release(client);
 
 client_error:
-- 
2.30.2



