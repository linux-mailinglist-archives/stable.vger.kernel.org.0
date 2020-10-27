Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE6329B7F2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902265AbgJ0P3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796686AbgJ0PTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF0C20657;
        Tue, 27 Oct 2020 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811989;
        bh=6fmavvFGRS7qOovt/b5GQG9Ett4XYIxHre/1/B5mpxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V70JzdM+/oZWfS9hSDbs0uijRghZpqCdbBcvo0Lt4mpiIQPXN9DTIZ4jW197RZu/F
         kVKcE/YkVXms/qlNjyPag79BHQY17zvehQqUwi0veKpwT7v4gm6pgcBBW/Debfe6yx
         FBABGq3zn7cKO989CHtmM/fB3fmslmKKpp1ZeQUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 054/757] net/sched: act_gate: Unlock ->tcfa_lock in tc_setup_flow_action()
Date:   Tue, 27 Oct 2020 14:45:04 +0100
Message-Id: <20201027135453.083130184@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit b130762161374b1ef31549bef8ebd4abeb998d94 ]

We need to jump to the "err_out_locked" label when
tcf_gate_get_entries() fails. Otherwise, tc_setup_flow_action() exits
with ->tcfa_lock still held.

Fixes: d29bdd69ecdd ("net: schedule: add action gate offloading")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://lore.kernel.org/r/12f60e385584c52c22863701c0185e40ab08a7a7.1603207948.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3712,7 +3712,7 @@ int tc_setup_flow_action(struct flow_act
 			entry->gate.num_entries = tcf_gate_num_entries(act);
 			err = tcf_gate_get_entries(entry, act);
 			if (err)
-				goto err_out;
+				goto err_out_locked;
 		} else {
 			err = -EOPNOTSUPP;
 			goto err_out_locked;


