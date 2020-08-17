Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCC524694A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgHQPTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729196AbgHQPSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:18:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07F6C20709;
        Mon, 17 Aug 2020 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677534;
        bh=lKORXuK1Vq7++6LFUb5ugaddd/IrZZClPHqLCVvqZtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsK4AgVLTuYItUoOFpE2jBtJYBYuKCpNBoQYZ6eMXQIfphb1Ee13gVH5zaP6JB9LW
         4zx7r43Fm6jrPpfSZ2fDW9CGvpTdYnHXlin1qbixujusFoOCv6ju2VKVEy413C8EHl
         RjZWYbYRihZ84VOgsHOfEJ+ULJ1rAFRJgVPq5O+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Chen <chenwi@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 002/464] kunit: capture stderr on all make subprocess calls
Date:   Mon, 17 Aug 2020 17:09:15 +0200
Message-Id: <20200817143833.855845762@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Chen <chenwi@google.com>

[ Upstream commit 5a9fcad71caa970f30aef99134a1cd19bc4b8eea ]

Direct stderr to subprocess.STDOUT so error messages get included in the
subprocess.CalledProcessError exceptions output field. This results in
more meaningful error messages for the user.

This is already being done in the make_allyesconfig method. Do the same
for make_mrproper, make_olddefconfig, and make methods.

With this, failures on unclean trees [1] will give users an error
message that includes:
"The source tree is not clean, please run 'make ARCH=um mrproper'"

[1] https://bugzilla.kernel.org/show_bug.cgi?id=205219

Signed-off-by: Will Chen <chenwi@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_kernel.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index 63dbda2d029f6..e20e2056cb380 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -34,7 +34,7 @@ class LinuxSourceTreeOperations(object):
 
 	def make_mrproper(self):
 		try:
-			subprocess.check_output(['make', 'mrproper'])
+			subprocess.check_output(['make', 'mrproper'], stderr=subprocess.STDOUT)
 		except OSError as e:
 			raise ConfigError('Could not call make command: ' + e)
 		except subprocess.CalledProcessError as e:
@@ -47,7 +47,7 @@ class LinuxSourceTreeOperations(object):
 		if build_dir:
 			command += ['O=' + build_dir]
 		try:
-			subprocess.check_output(command, stderr=subprocess.PIPE)
+			subprocess.check_output(command, stderr=subprocess.STDOUT)
 		except OSError as e:
 			raise ConfigError('Could not call make command: ' + e)
 		except subprocess.CalledProcessError as e:
@@ -77,7 +77,7 @@ class LinuxSourceTreeOperations(object):
 		if build_dir:
 			command += ['O=' + build_dir]
 		try:
-			subprocess.check_output(command)
+			subprocess.check_output(command, stderr=subprocess.STDOUT)
 		except OSError as e:
 			raise BuildError('Could not call execute make: ' + e)
 		except subprocess.CalledProcessError as e:
-- 
2.25.1



