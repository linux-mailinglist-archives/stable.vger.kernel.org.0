Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B39B35C0AA
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241276AbhDLJPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241014AbhDLJLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8959C61288;
        Mon, 12 Apr 2021 09:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218488;
        bh=o6/EnYGd7uPnVx04dsNL/GpaNHOMtI5F3bDzBPIBsdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFxeVLOAuySR0VhiZj6P/5oAyh+SvgiEBSST/lIeJI0IC48KQrz2endKwbBNxi2mi
         is8V/Ez2pXtmviqw60A9113qusuYlVI7ZyhwlcMRavIRd4UfsgkrTKRvlisJ+TQRnc
         Iya4uSXWo7qwwxiicG5oqfRN7pzbssZpd282RW+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 210/210] Revert "net: sched: bump refcount for new action in ACT replace mode"
Date:   Mon, 12 Apr 2021 10:41:55 +0200
Message-Id: <20210412084023.004668415@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

commit 4ba86128ba077fbb7d86516ae24ed642e6c3adef upstream.

This reverts commit 6855e8213e06efcaf7c02a15e12b1ae64b9a7149.

Following commit in series fixes the issue without introducing regression
in error rollback of tcf_action_destroy().

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1049,9 +1049,6 @@ struct tc_action *tcf_action_init_1(stru
 	if (!name)
 		a->hw_stats = hw_stats;
 
-	if (!bind && ovr && err == ACT_P_CREATED)
-		refcount_set(&a->tcfa_refcnt, 2);
-
 	return a;
 
 err_out:


