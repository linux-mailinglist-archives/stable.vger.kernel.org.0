Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA2D3B8109
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 13:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhF3LEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 07:04:55 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35596 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhF3LEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 07:04:50 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 00741224E1;
        Wed, 30 Jun 2021 11:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625050938; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZU0gun1V890/wTGVNAzxDj0L92mlUu6Ks+lF5DQO5pc=;
        b=eH/7peku6VHk2LMWow7pAGYepb0vBBe3NGOGkPU7LJDCk2NflHPkSVl1fBxXsmabwKCbDO
        a3llwhtuu1DP67MxT2wenZpZxEvR0zR6oS20/Aa7X1Y85iT8gK6XKaTlkSB1WqCJ9H8Ohe
        MWk6Qkha/8XraPWtZAgua85+IeWUC6A=
Received: from alley.suse.cz (unknown [10.100.224.162])
        by relay2.suse.de (Postfix) with ESMTP id 9B4A2A3B85;
        Wed, 30 Jun 2021 11:02:17 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        jenhaochen@google.com, liumartin@google.com, minchan@google.com,
        nathan@kernel.org, ndesaulniers@google.com, oleg@redhat.com,
        tj@kernel.org, torvalds@linux-foundation.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 0/2] kthread_worker: Fix race between kthread_mod_delayed_work()
Date:   Wed, 30 Jun 2021 13:01:47 +0200
Message-Id: <20210630110149.25086-1-pmladek@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <162480383515619@kroah.com>
References: <162480383515619@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport of the series for the following stable trees:

   + 4.9
   + 4.14
   + 4.19

The orignal series did not apply because of a conflict with the commit
("kthread: Convert worker lock to raw spinlock").

Petr Mladek (2):
  kthread_worker: split code for canceling the delayed work timer
  kthread: prevent deadlock when kthread_mod_delayed_work() races with
    kthread_cancel_delayed_work_sync()

 kernel/kthread.c | 77 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 26 deletions(-)

-- 
2.26.2

