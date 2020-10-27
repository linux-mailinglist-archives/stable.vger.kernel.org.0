Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC31429B37E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775175AbgJ0Owe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1770190AbgJ0Otx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9E820709;
        Tue, 27 Oct 2020 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810193;
        bh=NOz+Rc/zYTz16d+7g7w8zTb3992X5oy1n5Ouw5KLapM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVd084CrEBgFKmQ7CHdINxsiWgm0P5EDza22YcPDGY/Fpz9vEnQ8xa7qWjeKFeQrW
         i+bGFmo5IkxPW5RJldII7X1WhviAYG2FhxMRab43v7MuRtS0EQV+8uU9+kINsEG7FX
         lR08wt/EiS60Q45DjD2ibOPr49p0LQQKW18oQQLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 054/633] net/sched: act_gate: Unlock ->tcfa_lock in tc_setup_flow_action()
Date:   Tue, 27 Oct 2020 14:46:37 +0100
Message-Id: <20201027135525.238226269@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
@@ -3707,7 +3707,7 @@ int tc_setup_flow_action(struct flow_act
 			entry->gate.num_entries = tcf_gate_num_entries(act);
 			err = tcf_gate_get_entries(entry, act);
 			if (err)
-				goto err_out;
+				goto err_out_locked;
 		} else {
 			err = -EOPNOTSUPP;
 			goto err_out_locked;


