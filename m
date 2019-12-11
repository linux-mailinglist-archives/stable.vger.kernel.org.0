Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3D411B592
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbfLKPyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731796AbfLKPRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD22522B48;
        Wed, 11 Dec 2019 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077436;
        bh=rABFBufeE2chTN2Rb3oufunvCziO/+h2macQIz7EMV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CozBJe5hzxq+ofW2F+1HCxRNRFhPYaiW+VbH5PPF+LOkoR+FgoWmRSHvjnDNvOck1
         DcgzKXhauXu7iV2YShtJwvxxyuT9cpm74fGSJHH2pYzFRLMLPNHEe5/+grEUho7vuB
         1+P1OrzfLvysvZ2MrIK0QSOVhmyr0ObrgdfT9wpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/243] dlm: fix possible call to kfree() for non-initialized pointer
Date:   Wed, 11 Dec 2019 16:03:21 +0100
Message-Id: <20191211150341.825724832@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis V. Lunev <den@openvz.org>

[ Upstream commit 58a923adf4d9aca8bf7205985c9c8fc531c65d72 ]

Technically dlm_config_nodes() could return error and keep nodes
uninitialized. After that on the fail path of we'll call kfree()
for that uninitialized value.

The patch is simple - we should just initialize nodes with NULL.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/member.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index cad6d85911a80..0bc43b35d2c53 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -671,7 +671,7 @@ int dlm_ls_stop(struct dlm_ls *ls)
 int dlm_ls_start(struct dlm_ls *ls)
 {
 	struct dlm_recover *rv, *rv_old;
-	struct dlm_config_node *nodes;
+	struct dlm_config_node *nodes = NULL;
 	int error, count;
 
 	rv = kzalloc(sizeof(*rv), GFP_NOFS);
-- 
2.20.1



