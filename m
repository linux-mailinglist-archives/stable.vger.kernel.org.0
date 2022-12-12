Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391F964A287
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiLLNzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbiLLNzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:55:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96125BC4
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:55:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 330F561068
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151EAC433EF;
        Mon, 12 Dec 2022 13:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853312;
        bh=9lBQqhw4jsKspqxveYCdw/ReJg3uPm4au0POIR9UWMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X65dMEEDxHK+XFMxiSP7owytojMNP2+5Muhc8TyovF+OckpVOFBOMKpTGCOWUZNLP
         LH18myZcKPBAsBEoyPvUP6Pd1CZCPFIG7r6whBpuhl9uY12seSKi4Xol7JLOBMoT9S
         MbKrkttAPQEdAa1eeswizhvMOlEDXgxnxkRjao0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Connor Shu <Connor.Shu@ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/31] rcutorture: Automatically create initrd directory
Date:   Mon, 12 Dec 2022 14:19:27 +0100
Message-Id: <20221212130910.456183700@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor Shu <Connor.Shu@ibm.com>

[ Upstream commit 8f15c682ac5a778feb8e343f9057b89beb40d85b ]

The rcutorture scripts currently expect the user to create the
tools/testing/selftests/rcutorture/initrd directory.  Should the user
fail to do this, the kernel build will fail with obscure and confusing
error messages.  This commit therefore adds explicit checks for the
tools/testing/selftests/rcutorture/initrd directory, and if not present,
creates one on systems on which dracut is installed.  If this directory
could not be created, a less obscure error message is emitted and the
test is aborted.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Connor Shu <Connor.Shu@ibm.com>
[ paulmck: Adapt the script to fit into the rcutorture framework and
  severely abbreviate the initrd/init script. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh      |    8 ++
 tools/testing/selftests/rcutorture/bin/mkinitrd.sh |   60 +++++++++++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100755 tools/testing/selftests/rcutorture/bin/mkinitrd.sh

--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -175,6 +175,14 @@ do
 	shift
 done
 
+if test -z "$TORTURE_INITRD" || tools/testing/selftests/rcutorture/bin/mkinitrd.sh
+then
+	:
+else
+	echo No initrd and unable to create one, aborting test >&2
+	exit 1
+fi
+
 CONFIGFRAG=${KVM}/configs/${TORTURE_SUITE}; export CONFIGFRAG
 
 if test -z "$configs"
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/mkinitrd.sh
@@ -0,0 +1,60 @@
+#!/bin/bash
+#
+# Create an initrd directory if one does not already exist.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Author: Connor Shu <Connor.Shu@ibm.com>
+
+D=tools/testing/selftests/rcutorture
+
+# Prerequisite checks
+[ -z "$D" ] && echo >&2 "No argument supplied" && exit 1
+if [ ! -d "$D" ]; then
+    echo >&2 "$D does not exist: Malformed kernel source tree?"
+    exit 1
+fi
+if [ -d "$D/initrd" ]; then
+    echo "$D/initrd already exists, no need to create it"
+    exit 0
+fi
+
+T=${TMPDIR-/tmp}/mkinitrd.sh.$$
+trap 'rm -rf $T' 0 2
+mkdir $T
+
+cat > $T/init << '__EOF___'
+#!/bin/sh
+while :
+do
+	sleep 1000000
+done
+__EOF___
+
+# Try using dracut to create initrd
+command -v dracut >/dev/null 2>&1 || { echo >&2 "Dracut not installed"; exit 1; }
+echo Creating $D/initrd using dracut.
+
+# Filesystem creation
+dracut --force --no-hostonly --no-hostonly-cmdline --module "base" $T/initramfs.img
+cd $D
+mkdir initrd
+cd initrd
+zcat $T/initramfs.img | cpio -id
+cp $T/init init
+echo Done creating $D/initrd using dracut
+exit 0


