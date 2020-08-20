Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEC324B813
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgHTLIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729753AbgHTKK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:10:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C46206DA;
        Thu, 20 Aug 2020 10:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918227;
        bh=VsjZbyDoFnSpuIJdUWlBT69iwFkVIb5It172DSCdcZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W++wVTKbpZFbCxhNR07K6P6aRhIjFL3PQ92doA7ZhmOUEocfG1BbAJX2+iEsCL7l9
         m8lJbEa7k/f8JyijtFVtnStOI2+iBG/pZi6qfQOkiK1ZQx4EBXeEKGOnD3FkaZyM5p
         uWCiz4ezgCMItSwQXpMx+gfpGMOcjn/sXInX+6wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/228] media: firewire: Using uninitialized values in node_probe()
Date:   Thu, 20 Aug 2020 11:21:12 +0200
Message-Id: <20200820091612.470583130@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 2505a210fc126599013aec2be741df20aaacc490 ]

If fw_csr_string() returns -ENOENT, then "name" is uninitialized.  So
then the "strlen(model_names[i]) <= name_len" is true because strlen()
is unsigned and -ENOENT is type promoted to a very high positive value.
Then the "strncmp(name, model_names[i], name_len)" uses uninitialized
data because "name" is uninitialized.

Fixes: 92374e886c75 ("[media] firedtv: drop obsolete backend abstraction")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/firewire/firedtv-fw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/firewire/firedtv-fw.c b/drivers/media/firewire/firedtv-fw.c
index 247f0e7cb5f7f..5d634706a7eaa 100644
--- a/drivers/media/firewire/firedtv-fw.c
+++ b/drivers/media/firewire/firedtv-fw.c
@@ -271,6 +271,8 @@ static int node_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
 
 	name_len = fw_csr_string(unit->directory, CSR_MODEL,
 				 name, sizeof(name));
+	if (name_len < 0)
+		return name_len;
 	for (i = ARRAY_SIZE(model_names); --i; )
 		if (strlen(model_names[i]) <= name_len &&
 		    strncmp(name, model_names[i], name_len) == 0)
-- 
2.25.1



