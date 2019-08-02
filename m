Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D747FAFD
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393290AbfHBNUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393279AbfHBNUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4F3721849;
        Fri,  2 Aug 2019 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752004;
        bh=Ox3OSVFSSuA8AE3wsWrSZiJu9cLwjfZISkLaYsNRfHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OCPTeE89DyrgcKDxX0T+Yt2htFCNmYv32XNJ3SMO2V8kDQcMX4tMKj5rdIEZfYp6
         xRWy0uc0z4upqtOqEukwAWg02L1FbhMeIG6IN1Cp0+A77a4HSQgs7pMrHVNlqn0vqQ
         gEss4CECa4cRyixnBRNHHNaebiqdwQ9uIPXkv3iE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 10/76] scripts/sphinx-pre-install: don't use LaTeX with CentOS 7
Date:   Fri,  2 Aug 2019 09:18:44 -0400
Message-Id: <20190802131951.11600-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

[ Upstream commit 56e5a633923793b31515795ad30156a307572c1e ]

There aren't enough texlive packages for LaTeX-based builds
to work on CentOS/RHEL <= 7.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/sphinx-pre-install | 68 ++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 18 deletions(-)

diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
index 778f3ae918775..4cc2b3ee5209f 100755
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -77,6 +77,17 @@ sub check_missing(%)
 	foreach my $prog (sort keys %missing) {
 		my $is_optional = $missing{$prog};
 
+		# At least on some LTS distros like CentOS 7, texlive doesn't
+		# provide all packages we need. When such distros are
+		# detected, we have to disable PDF output.
+		#
+		# So, we need to ignore the packages that distros would
+		# need for LaTeX to work
+		if ($is_optional == 2 && !$pdf) {
+			$optional--;
+			next;
+		}
+
 		if ($is_optional) {
 			print "Warning: better to also install \"$prog\".\n";
 		} else {
@@ -326,10 +337,10 @@ sub give_debian_hints()
 
 	if ($pdf) {
 		check_missing_file("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
-				   "fonts-dejavu", 1);
+				   "fonts-dejavu", 2);
 	}
 
-	check_program("dvipng", 1) if ($pdf);
+	check_program("dvipng", 2) if ($pdf);
 	check_missing(\%map);
 
 	return if (!$need && !$optional);
@@ -364,22 +375,40 @@ sub give_redhat_hints()
 	#
 	# Checks valid for RHEL/CentOS version 7.x.
 	#
+	my $old = 0;
+	my $rel;
+	$rel = $1 if ($system_release =~ /release\s+(\d+)/);
+
 	if (!($system_release =~ /Fedora/)) {
 		$map{"virtualenv"} = "python-virtualenv";
-	}
 
-	my $release;
+		if ($rel && $rel < 8) {
+			$old = 1;
+			$pdf = 0;
 
-	$release = $1 if ($system_release =~ /Fedora\s+release\s+(\d+)/);
+			printf("Note: texlive packages on RHEL/CENTOS <= 7 are incomplete. Can't support PDF output\n");
+			printf("If you want to build PDF, please read:\n");
+			printf("\thttps://www.systutorials.com/241660/how-to-install-tex-live-on-centos-7-linux/\n");
+		}
+	} else {
+		if ($rel && $rel < 26) {
+			$old = 1;
+		}
+	}
+	if (!$rel) {
+		printf("Couldn't identify release number\n");
+		$old = 1;
+		$pdf = 0;
+	}
 
-	check_rpm_missing(\@fedora26_opt_pkgs, 1) if ($pdf && $release >= 26);
-	check_rpm_missing(\@fedora_tex_pkgs, 1) if ($pdf);
-	check_missing_tex(1) if ($pdf);
+	check_rpm_missing(\@fedora26_opt_pkgs, 2) if ($pdf && !$old);
+	check_rpm_missing(\@fedora_tex_pkgs, 2) if ($pdf);
+	check_missing_tex(2) if ($pdf);
 	check_missing(\%map);
 
 	return if (!$need && !$optional);
 
-	if ($release >= 18) {
+	if (!$old) {
 		# dnf, for Fedora 18+
 		printf("You should run:\n\n\tsudo dnf install -y $install\n");
 	} else {
@@ -418,8 +447,8 @@ sub give_opensuse_hints()
 		"texlive-zapfding",
 	);
 
-	check_rpm_missing(\@suse_tex_pkgs, 1) if ($pdf);
-	check_missing_tex(1) if ($pdf);
+	check_rpm_missing(\@suse_tex_pkgs, 2) if ($pdf);
+	check_missing_tex(2) if ($pdf);
 	check_missing(\%map);
 
 	return if (!$need && !$optional);
@@ -443,7 +472,7 @@ sub give_mageia_hints()
 		"texlive-fontsextra",
 	);
 
-	check_rpm_missing(\@tex_pkgs, 1) if ($pdf);
+	check_rpm_missing(\@tex_pkgs, 2) if ($pdf);
 	check_missing(\%map);
 
 	return if (!$need && !$optional);
@@ -466,7 +495,8 @@ sub give_arch_linux_hints()
 		"texlive-latexextra",
 		"ttf-dejavu",
 	);
-	check_pacman_missing(\@archlinux_tex_pkgs, 1) if ($pdf);
+	check_pacman_missing(\@archlinux_tex_pkgs, 2) if ($pdf);
+
 	check_missing(\%map);
 
 	return if (!$need && !$optional);
@@ -485,7 +515,7 @@ sub give_gentoo_hints()
 	);
 
 	check_missing_file("/usr/share/fonts/dejavu/DejaVuSans.ttf",
-			   "media-fonts/dejavu", 1) if ($pdf);
+			   "media-fonts/dejavu", 2) if ($pdf);
 
 	check_missing(\%map);
 
@@ -553,7 +583,7 @@ sub check_distros()
 	my %map = (
 		"sphinx-build" => "sphinx"
 	);
-	check_missing_tex(1) if ($pdf);
+	check_missing_tex(2) if ($pdf);
 	check_missing(\%map);
 	print "I don't know distro $system_release.\n";
 	print "So, I can't provide you a hint with the install procedure.\n";
@@ -591,11 +621,13 @@ sub check_needs()
 	check_program("make", 0);
 	check_program("gcc", 0);
 	check_python_module("sphinx_rtd_theme", 1) if (!$virtualenv);
-	check_program("xelatex", 1) if ($pdf);
 	check_program("dot", 1);
 	check_program("convert", 1);
-	check_program("rsvg-convert", 1) if ($pdf);
-	check_program("latexmk", 1) if ($pdf);
+
+	# Extra PDF files - should use 2 for is_optional
+	check_program("xelatex", 2) if ($pdf);
+	check_program("rsvg-convert", 2) if ($pdf);
+	check_program("latexmk", 2) if ($pdf);
 
 	check_distros();
 
-- 
2.20.1

