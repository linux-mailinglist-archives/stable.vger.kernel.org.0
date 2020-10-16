Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846D5290696
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408415AbgJPNsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:48:50 -0400
Received: from linux.microsoft.com ([13.77.154.182]:53624 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408409AbgJPNsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:48:50 -0400
Received: from localhost.localdomain (c-73-172-233-15.hsd1.md.comcast.net [73.172.233.15])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3A41520B4905;
        Fri, 16 Oct 2020 06:48:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3A41520B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602856129;
        bh=1oc/zAntSt+hZ0cOMu1NfyfaUbHs8ymUvM+s7CKB9zQ=;
        h=From:To:Cc:Subject:Date:From;
        b=UW0qV7Pxku1fglcLxrAVmjWooYaanqzHTyZfNsgY69onzN7uAKYX4gKdwkNGj5Gqq
         E+TCCKfqa1VEnfHgAoe7ZnUNlS5aNUaWhAeD/60GEF8DHhoZyDOjzgHbc8XqNAJmd0
         CbMQXtezo6kB6tzURnBvpcN4P8+Yxk68RdiZCgPU=
From:   Daniel Burgener <dburgener@linux.microsoft.com>
To:     stable@vger.kernel.org
Cc:     stephen.smalley.work@gmail.com, paul@paul-moore.com,
        selinux@vger.kernel.org, jmorris@namei.org, sashal@kernel.org
Subject: [PATCH v5.4 v2 0/4] Update SELinuxfs out of tree and then swapover
Date:   Fri, 16 Oct 2020 09:48:31 -0400
Message-Id: <20201016134835.1886478-1-dburgener@linux.microsoft.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v2: Include all commits from original series, and include commit ids

This is a backport for stable of my series to fix a race condition in
selinuxfs during policy load:

selinux: Create function for selinuxfs directory cleanup
https://lore.kernel.org/selinux/20200819195935.1720168-2-dburgener@linux.microsoft.com/

selinux: Refactor selinuxfs directory populating functions
https://lore.kernel.org/selinux/20200819195935.1720168-3-dburgener@linux.microsoft.com/

selinux: Standardize string literal usage for selinuxfs directory names
https://lore.kernel.org/selinux/20200819195935.1720168-4-dburgener@linux.microsoft.com/

selinux: Create new booleans and class dirs out of tree
https://lore.kernel.org/selinux/20200819195935.1720168-5-dburgener@linux.microsoft.com/

Several changes were necessary to backport.  They are detailed in the
commit message for the third commit in the series.

The bulk of the original cover letter is reproduced below.

In the current implementation, on policy load /sys/fs/selinux is updated
by deleting the previous contents of
/sys/fs/selinux/{class,booleans} and then recreating them.  This means
that there is a period of time when the contents of these directories do
not exist which can cause race conditions as userspace relies on them for
information about the policy.  In addition, it means that error recovery
in the event of failure is challenging.

This patch series follows the design outlined by Al Viro in a previous
e-mail to the list[1].  This approach is to first create the new
directory structures out of tree, then to perform the swapover, and
finally to delete the old directories.  Not handled in this series is
error recovery in the event of failure.

Error recovery in the selinuxfs recreation is unhandled in the current
code, so this series will not cause any regression in this regard.
Handling directory recreation in this manner is a prerequisite to make
proper error handling possible.

In order to demonstrate the race condition that this series fixes, you
can use the following commands:

while true; do cat /sys/fs/selinux/class/service/perms/status
>/dev/null; done &
while true; do load_policy; done;

In the existing code, this will display errors fairly often as the class
lookup fails.  (In normal operation from systemd, this would result in a
permission check which would be allowed or denied based on policy settings
around unknown object classes.) After applying this patch series you
should expect to no longer see such error messages.

Daniel Burgener (4):
  selinux: Create function for selinuxfs directory cleanup
  selinux: Refactor selinuxfs directory populating functions
  selinux: Standardize string literal usage for selinuxfs directory
    names
  selinux: Create new booleans and class dirs out of tree

 security/selinux/selinuxfs.c | 168 +++++++++++++++++++++++++++--------
 1 file changed, 129 insertions(+), 39 deletions(-)

-- 
2.25.4

