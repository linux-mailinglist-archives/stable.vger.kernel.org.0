Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C2A499C86
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579566AbiAXWF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577771AbiAXWBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:01:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03170C02B8F7;
        Mon, 24 Jan 2022 12:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9466461542;
        Mon, 24 Jan 2022 20:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652B6C340ED;
        Mon, 24 Jan 2022 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056809;
        bh=TElkjlzuCBV3Gc3JqGNMR1z/jwiZxTMPgmvaZtwLM8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeVCzfIXdKwKxfkskB6/9LZu2DXY9g83p5QcEPuSuf+7WS2WFzdmWmoQKbXZhVOpp
         oSFlFSwaD78z6aTi3JBhyFj24cKiDaX6qE+zQFu4oR1Y5pj2bAfiWn/dB07QWEm9q1
         XPK4abMrcJ2WVwTTDVCx/u4h2duLy6aGceltKOgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <haliu@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 606/846] bpf/selftests: Fix namespace mount setup in tc_redirect
Date:   Mon, 24 Jan 2022 19:42:03 +0100
Message-Id: <20220124184121.927835297@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index e7201ba29ccd6..47e3159729d21 100644
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



