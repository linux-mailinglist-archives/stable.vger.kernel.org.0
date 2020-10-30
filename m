Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941A52A05B4
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 13:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgJ3MrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 08:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgJ3MrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 08:47:00 -0400
X-Greylist: delayed 429 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 30 Oct 2020 05:46:09 PDT
Received: from smtp-bc09.mail.infomaniak.ch (smtp-bc09.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc09])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25ABC0613D2
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 05:46:09 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4CN21D2LbdzlhVrr;
        Fri, 30 Oct 2020 13:38:56 +0100 (CET)
Received: from localhost (unknown [94.23.54.103])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4CN21C3xR3zlh8TQ;
        Fri, 30 Oct 2020 13:38:55 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 0/2] Fix misuse of security_capable()
Date:   Fri, 30 Oct 2020 13:38:47 +0100
Message-Id: <20201030123849.770769-1-mic@digikod.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series replaces all the use of security_capable(current_cred(),
...) with ns_capable{,_noaudit}() which set PF_SUPERPRIV.

This initially come from a review of Landlock by Jann Horn:
https://lore.kernel.org/lkml/CAG48ez1FQVkt78129WozBwFbVhAPyAr9oJAHFHAbbNxEBr9h1g@mail.gmail.com/

Mickaël Salaün (2):
  ptrace: Set PF_SUPERPRIV when checking capability
  seccomp: Set PF_SUPERPRIV when checking capability

 kernel/ptrace.c  | 18 ++++++------------
 kernel/seccomp.c |  5 ++---
 2 files changed, 8 insertions(+), 15 deletions(-)


base-commit: 3650b228f83adda7e5ee532e2b90429c03f7b9ec
-- 
2.28.0

