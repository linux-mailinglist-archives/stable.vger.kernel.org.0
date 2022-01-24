Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4754B4999EE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378127AbiAXViv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49604 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453214AbiAXV26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:28:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 320A9614DE;
        Mon, 24 Jan 2022 21:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA39C33E60;
        Mon, 24 Jan 2022 21:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059736;
        bh=UD6Ht1hPoWlejkDH/Gzpu/erG3jhCpBQYjkRtuiDRoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJqCFMmOABegN9HEYI4t/yZsW+cN3L/BxVaPY51UuS2I2CHL7Rw0S8SQJLS5TMhy/
         omJSs6u29xr6bEvLFbi/or4bOqPXEIwllvJ+ObgIi627XlrxwXlMkt/idPapmLEdTr
         wnaspKGZW9HxYp11JGYqX9LezvEG37WnAwie6/Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <haliu@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0716/1039] bpf/selftests: Fix namespace mount setup in tc_redirect
Date:   Mon, 24 Jan 2022 19:41:45 +0100
Message-Id: <20220124184149.401200286@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

[ Upstream commit 5e22dd18626726028a93ff1350a8a71a00fd843d ]

The tc_redirect umounts /sys in the new namespace, which can be
mounted as shared and cause global umount. The lazy umount also
takes down mounted trees under /sys like debugfs, which won't be
available after sysfs mounts again and could cause fails in other
tests.

  # cat /proc/self/mountinfo | grep debugfs
  34 23 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime shared:14 - debugfs debugfs rw
  # cat /proc/self/mountinfo | grep sysfs
  23 86 0:22 / /sys rw,nosuid,nodev,noexec,relatime shared:2 - sysfs sysfs rw
  # mount | grep debugfs
  debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)

  # ./test_progs -t tc_redirect
  #164 tc_redirect:OK
  Summary: 1/4 PASSED, 0 SKIPPED, 0 FAILED

  # mount | grep debugfs
  # cat /proc/self/mountinfo | grep debugfs
  # cat /proc/self/mountinfo | grep sysfs
  25 86 0:22 / /sys rw,relatime shared:2 - sysfs sysfs rw

Making the sysfs private under the new namespace so the umount won't
trigger the global sysfs umount.

Reported-by: Hangbin Liu <haliu@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jussi Maki <joamaki@gmail.com>
Link: https://lore.kernel.org/bpf/20220104121030.138216-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tc_redirect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index 4b18b73df10b6..c2426df58e172 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -105,6 +105,13 @@ static int setns_by_fd(int nsfd)
 	if (!ASSERT_OK(err, "unshare"))
 		return err;
 
+	/* Make our /sys mount private, so the following umount won't
+	 * trigger the global umount in case it's shared.
+	 */
+	err = mount("none", "/sys", NULL, MS_PRIVATE, NULL);
+	if (!ASSERT_OK(err, "remount private /sys"))
+		return err;
+
 	err = umount2("/sys", MNT_DETACH);
 	if (!ASSERT_OK(err, "umount2 /sys"))
 		return err;
-- 
2.34.1



