Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F1D1B0B75
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgDTMpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgDTMpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C7EA206DD;
        Mon, 20 Apr 2020 12:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386718;
        bh=Rh5hxvpqpcpQpqS+P4DEnb+HnabaCbgXcvHCZKbP88Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6KYTB8CNfrKWpDAleR4iOu/Ntca/rVgzexFlLGlujsRRTiy+68BAZfokY4bS+MtW
         4nssdBdXaQXoZ62bo/4+1rNvZbIKAb3HpSTfTlKa9dYeoQqNSiF5zZFuxo3qTt4VHc
         d+LF95+sKz1+NX+h2QI8xnVZu470SlpAluqiVXow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Kundu <rahul.kundu@chelsio.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 71/71] scsi: target: iscsi: calling iscsit_stop_session() inside iscsit_close_session() has no effect
Date:   Mon, 20 Apr 2020 14:39:25 +0200
Message-Id: <20200420121522.825413903@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 626bac73371eed79e2afa2966de393da96cf925e ]

iscsit_close_session() can only be called when nconn is zero (otherwise a
kernel panic is triggered). If nconn is zero then iscsit_stop_session()
does nothing and exits, so calling it makes no sense.

We still need to call iscsit_check_session_usage_count() because this
function will sleep if the session's refcount is not zero and we don't want
to destroy the session structure if it's still being referenced.

Link: https://lore.kernel.org/r/20200313170656.9716-4-mlombard@redhat.com
Tested-by: Rahul Kundu <rahul.kundu@chelsio.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 09e55ea0bf5d5..9fc7e374a29b4 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4368,8 +4368,7 @@ int iscsit_close_session(struct iscsi_session *sess)
 	 * restart the timer and exit.
 	 */
 	if (!in_interrupt()) {
-		if (iscsit_check_session_usage_count(sess) == 1)
-			iscsit_stop_session(sess, 1, 1);
+		iscsit_check_session_usage_count(sess);
 	} else {
 		if (iscsit_check_session_usage_count(sess) == 2) {
 			atomic_set(&sess->session_logout, 0);
-- 
2.20.1



