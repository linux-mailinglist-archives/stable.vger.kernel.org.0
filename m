Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E2747AE80
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbhLTPBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47098 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239350AbhLTO6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F073161183;
        Mon, 20 Dec 2021 14:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D731EC36AE8;
        Mon, 20 Dec 2021 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012312;
        bh=YoctKyMc9y15TmSWmn8sk6ZHJuGXrzJbQp8ReV9Pb/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjyyz/NtiIpmYDO3ba5qeOZA8ol9vzBghcbA7OCkrDlwQWdixvq2jrkplhIwzI48p
         T3oDnTqeb5Fi1hOC3Xtjc67Qzh4672mtzNy2oFcB3A8cL4VueTHQ2QJUnCZzTKfsUz
         qh2NaH9ceWY+6HlCJk3L8W8W/9WIB9ctI63UjEZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 156/177] mptcp: add missing documented NL params
Date:   Mon, 20 Dec 2021 15:35:06 +0100
Message-Id: <20211220143045.330843043@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 6813b1928758ce64fabbb8ef157f994b7c2235fa upstream.

'loc_id' and 'rem_id' are set in all events linked to subflows but those
were missing in the events description in the comments.

Fixes: b911c97c7dc7 ("mptcp: add netlink event support")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/mptcp.h |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -129,19 +129,21 @@ struct mptcp_info {
  * MPTCP_EVENT_REMOVED: token, rem_id
  * An address has been lost by the peer.
  *
- * MPTCP_EVENT_SUB_ESTABLISHED: token, family, saddr4 | saddr6,
- *                              daddr4 | daddr6, sport, dport, backup,
- *                              if_idx [, error]
+ * MPTCP_EVENT_SUB_ESTABLISHED: token, family, loc_id, rem_id,
+ *                              saddr4 | saddr6, daddr4 | daddr6, sport,
+ *                              dport, backup, if_idx [, error]
  * A new subflow has been established. 'error' should not be set.
  *
- * MPTCP_EVENT_SUB_CLOSED: token, family, saddr4 | saddr6, daddr4 | daddr6,
- *                         sport, dport, backup, if_idx [, error]
+ * MPTCP_EVENT_SUB_CLOSED: token, family, loc_id, rem_id, saddr4 | saddr6,
+ *                         daddr4 | daddr6, sport, dport, backup, if_idx
+ *                         [, error]
  * A subflow has been closed. An error (copy of sk_err) could be set if an
  * error has been detected for this subflow.
  *
- * MPTCP_EVENT_SUB_PRIORITY: token, family, saddr4 | saddr6, daddr4 | daddr6,
- *                           sport, dport, backup, if_idx [, error]
- *       The priority of a subflow has changed. 'error' should not be set.
+ * MPTCP_EVENT_SUB_PRIORITY: token, family, loc_id, rem_id, saddr4 | saddr6,
+ *                           daddr4 | daddr6, sport, dport, backup, if_idx
+ *                           [, error]
+ * The priority of a subflow has changed. 'error' should not be set.
  */
 enum mptcp_event_type {
 	MPTCP_EVENT_UNSPEC = 0,


