Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF3232E8D7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhCEM3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:29:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230423AbhCEM2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0484665013;
        Fri,  5 Mar 2021 12:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947335;
        bh=2Wgx6MVISznKDkpBBkDYzJNMeTM6PiEZhJpfXbZ2p9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wR8wJv8YCiM0qqPcgSqlt8I5rEhfyODZvCYP2ANIWCM5v2Qiu3x5BF8S6QE4OWA9e
         nwGYnudcK4vB9oorzTUetlkhLCOWx3RfqcqyV7q0VYjNdwWEa5CrNtUJLYqMDVmnLg
         fXOUo7wubfQihY3ldzKZZmvmRGWGRlB4TwpJ5rSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Wenzel <marco.wenzel@a-eberle.de>,
        George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 029/102] net: hsr: add support for EntryForgetTime
Date:   Fri,  5 Mar 2021 13:20:48 +0100
Message-Id: <20210305120904.712123059@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Wenzel <marco.wenzel@a-eberle.de>

commit f176411401127a07a9360dec14eca448eb2e9d45 upstream.

In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms. When a
node does not send any frame within this time, the sequence number check
for can be ignored. This solves communication issues with Cisco IE 2000
in Redbox mode.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>
Reviewed-by: George McCollister <george.mccollister@gmail.com>
Tested-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210224094653.1440-1-marco.wenzel@a-eberle.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_framereg.c |    9 +++++++--
 net/hsr/hsr_framereg.h |    1 +
 net/hsr/hsr_main.h     |    1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -164,8 +164,10 @@ static struct hsr_node *hsr_add_node(str
 	 * as initialization. (0 could trigger an spurious ring error warning).
 	 */
 	now = jiffies;
-	for (i = 0; i < HSR_PT_PORTS; i++)
+	for (i = 0; i < HSR_PT_PORTS; i++) {
 		new_node->time_in[i] = now;
+		new_node->time_out[i] = now;
+	}
 	for (i = 0; i < HSR_PT_PORTS; i++)
 		new_node->seq_out[i] = seq_out;
 
@@ -411,9 +413,12 @@ void hsr_register_frame_in(struct hsr_no
 int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 			   u16 sequence_nr)
 {
-	if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]))
+	if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &&
+	    time_is_after_jiffies(node->time_out[port->type] +
+	    msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)))
 		return 1;
 
+	node->time_out[port->type] = jiffies;
 	node->seq_out[port->type] = sequence_nr;
 	return 0;
 }
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -75,6 +75,7 @@ struct hsr_node {
 	enum hsr_port_type	addr_B_port;
 	unsigned long		time_in[HSR_PT_PORTS];
 	bool			time_in_stale[HSR_PT_PORTS];
+	unsigned long		time_out[HSR_PT_PORTS];
 	/* if the node is a SAN */
 	bool			san_a;
 	bool			san_b;
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -21,6 +21,7 @@
 #define HSR_LIFE_CHECK_INTERVAL		 2000 /* ms */
 #define HSR_NODE_FORGET_TIME		60000 /* ms */
 #define HSR_ANNOUNCE_INTERVAL		  100 /* ms */
+#define HSR_ENTRY_FORGET_TIME		  400 /* ms */
 
 /* By how much may slave1 and slave2 timestamps of latest received frame from
  * each node differ before we notify of communication problem?


