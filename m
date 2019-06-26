Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6DC56ADE
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 15:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfFZNj5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 26 Jun 2019 09:39:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfFZNj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 09:39:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 575C63086204;
        Wed, 26 Jun 2019 13:39:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-57.rdu2.redhat.com [10.10.120.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E299160852;
        Wed, 26 Jun 2019 13:39:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     torvalds@linux-foundation.org
cc:     dhowells@redhat.com, iwienand@redhat.com,
        linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [GIT PULL] AFS fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11570.1561556393.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 26 Jun 2019 14:39:53 +0100
Message-ID: <11571.1561556393@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 26 Jun 2019 13:39:56 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

Could you pull this please?

There are four patches:

 (1) Fix the printing of the "vnode modified" warning to exclude checks on
     files for which we don't have a callback promise from the server (and
     so don't expect the server to tell us when it changes).

     Without this, for every file or directory for which we still have an
     in-core inode that gets changed on the server, we may get a message
     logged when we next look at it.  This can happen in bulk if, for
     instance, someone does "vos release" to update a R/O volume from a R/W
     volume and a whole set of files are all changed together.

     We only really want to log a message if the file changed and the
     server didn't tell us about it or we failed to track the state
     internally.

 (2) Fix accidental corruption of either afs_vlserver struct objects or the
     the following memory locations (which could hold anything).  The issue
     is caused by a union that points to two different structs in struct
     afs_call (to save space in the struct).  The call cleanup code assumes
     that it can simply call the cleanup for one of those structs if not
     NULL - when it might be actually pointing to the other struct.

     This means that every Volume Location RPC op is going to corrupt
     something.

 (3) Fix an uninitialised spinlock.  This isn't too bad, it just causes a
     one-off warning if lockdep is enabled when "vos release" is called,
     but the spinlock still behaves correctly.

 (4) Fix the setting of i_block in the inode.  This causes du, for example,
     to produce incorrect results, but otherwise should not be dangerous to
     the kernel.

The in-kernel AFS client has been undergoing testing on opendev.org on one
of their mirror machines.  They are using AFS to hold data that is then
served via apache, and Ian Wienand had reported seeing oopses, spontaneous
machine reboots and updates to volumes going missing.  This patch series
appears to have fixed the problem, very probably due to patch (2), but it's
not 100% certain.

Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Ian Wienand <iwienand@redhat.com>

---
The following changes since commit a188339ca5a396acc588e5851ed7e19f66b0ebd9:

  Linux 5.2-rc1 (2019-05-19 15:47:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/afs-fixes-20190620

for you to fetch changes up to 2cd42d19cffa0ec3dfb57b1b3e1a07a9bf4ed80a:

  afs: Fix setting of i_blocks (2019-06-20 18:12:02 +0100)

----------------------------------------------------------------
AFS fixes

----------------------------------------------------------------
David Howells (4):
      afs: Fix over zealous "vnode modified" warnings
      afs: Fix vlserver record corruption
      afs: Fix uninitialised spinlock afs_volume::cb_break_lock
      afs: Fix setting of i_blocks

 fs/afs/callback.c |  4 ++--
 fs/afs/inode.c    | 31 +++++++++++++++++++------------
 fs/afs/internal.h |  8 +++-----
 fs/afs/volume.c   |  1 +
 4 files changed, 25 insertions(+), 19 deletions(-)
