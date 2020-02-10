Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC1E15788F
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgBJNIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728968AbgBJMj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:29 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F31D20733;
        Mon, 10 Feb 2020 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338368;
        bh=J62eTd3bqr5j/L4W1LyHoRheWIg3gYLbwbNKiE5D1Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1vR7aXl5Tq3kwmzDXFioElrNzpJB6SfZ4WarQHMp/qsPzSve0a9njU+y8YyLf0Uf
         350Fl9DmOIFlPK35mBhg+pH6d8tcv3L3v4FW9CY3zxpCsni/H/Oa2jm0eetb+WZdZX
         m/U/RSEZmKsUKq0qQKO0ZAN/QVpmU2cicH5WDlyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+99f4ddade3c22ab0cf23@syzkaller.appspotmail.com,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Subject: [PATCH 5.5 037/367] rcu: Use READ_ONCE() for ->expmask in rcu_read_unlock_special()
Date:   Mon, 10 Feb 2020 04:29:10 -0800
Message-Id: <20200210122427.406919433@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit c51f83c315c392d9776c33eb16a2fe1349d65c7f upstream.

The rcu_node structure's ->expmask field is updated only when holding the
->lock, but is also accessed locklessly.  This means that all ->expmask
updates must use WRITE_ONCE() and all reads carried out without holding
->lock must use READ_ONCE().  This commit therefore changes the lockless
->expmask read in rcu_read_unlock_special() to use READ_ONCE().

Reported-by: syzbot+99f4ddade3c22ab0cf23@syzkaller.appspotmail.com
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcu/tree_plugin.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -612,7 +612,7 @@ static void rcu_read_unlock_special(stru
 
 		t->rcu_read_unlock_special.b.exp_hint = false;
 		exp = (t->rcu_blocked_node && t->rcu_blocked_node->exp_tasks) ||
-		      (rdp->grpmask & rnp->expmask) ||
+		      (rdp->grpmask & READ_ONCE(rnp->expmask)) ||
 		      tick_nohz_full_cpu(rdp->cpu);
 		// Need to defer quiescent state until everything is enabled.
 		if (irqs_were_disabled && use_softirq &&


