Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E781D82DB
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgERR75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732141AbgERR7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E249B2083E;
        Mon, 18 May 2020 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824794;
        bh=Fgeb+u4i6DCoFrOwLCfwV3SRX91iUUYUiUQXuTT70DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvU1mlpaNqtKuteuGzUl46sNYuIl404e6GijfQiCfX3Yqss05lP0o5jef0HS9S/8T
         RCbhg/OBbD7nACyqr4b6FqtzkhOPRYUFXca+bintVzEAnSu2hgGDR1Sf9OWkMvHAG1
         mRESMAurCkIX1lor9jBHvCkuabTf7rWH97q4MEB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>, Rachel Sibley <rasibley@redhat.com>
Subject: [PATCH 5.4 126/147] fanotify: fix merging marks masks with FAN_ONDIR
Date:   Mon, 18 May 2020 19:37:29 +0200
Message-Id: <20200518173528.580032936@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 55bf882c7f13dda8bbe624040c6d5b4fbb812d16 upstream.

Change the logic of FAN_ONDIR in two ways that are similar to the logic
of FAN_EVENT_ON_CHILD, that was fixed in commit 54a307ba8d3c ("fanotify:
fix logic of events on child"):

1. The flag is meaningless in ignore mask
2. The flag refers only to events in the mask of the mark where it is set

This is what the fanotify_mark.2 man page says about FAN_ONDIR:
"Without this flag, only events for files are created."  It doesn't
say anything about setting this flag in ignore mask to stop getting
events on directories nor can I think of any setup where this capability
would be useful.

Currently, when marks masks are merged, the FAN_ONDIR flag set in one
mark affects the events that are set in another mark's mask and this
behavior causes unexpected results.  For example, a user adds a mark on a
directory with mask FAN_ATTRIB | FAN_ONDIR and a mount mark with mask
FAN_OPEN (without FAN_ONDIR).  An opendir() of that directory (which is
inside that mount) generates a FAN_OPEN event even though neither of the
marks requested to get open events on directories.

Link: https://lore.kernel.org/r/20200319151022.31456-10-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Rachel Sibley <rasibley@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fanotify/fanotify.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -172,6 +172,13 @@ static u32 fanotify_group_event_mask(str
 			continue;
 		mark = iter_info->marks[type];
 		/*
+		 * If the event is on dir and this mark doesn't care about
+		 * events on dir, don't send it!
+		 */
+		if (event_mask & FS_ISDIR && !(mark->mask & FS_ISDIR))
+			continue;
+
+		/*
 		 * If the event is for a child and this mark doesn't care about
 		 * events on a child, don't send it!
 		 */
@@ -203,10 +210,6 @@ static u32 fanotify_group_event_mask(str
 		user_mask &= ~FAN_ONDIR;
 	}
 
-	if (event_mask & FS_ISDIR &&
-	    !(marks_mask & FS_ISDIR & ~marks_ignored_mask))
-		return 0;
-
 	return test_mask & user_mask;
 }
 


