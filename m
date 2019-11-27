Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FD010BCFD
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbfK0U7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:59:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731463AbfK0U7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:59:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F6C120678;
        Wed, 27 Nov 2019 20:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888391;
        bh=Y18yuxI31zdXm3BrZcwrM5f7T94WmOvlXVgoXwJyH2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTSaPZlCvsAnBRM8s4RwmiFNU7fHEVQwOeiLXE1hfC0xHT/jlT3pJlKquDSYLbrTf
         5PH/LehrmvEeyGRAlFV7LaJ2mAHdj414TSt9HlcSdyJ5Ty/vM0czCwAv/ZMGrusLjN
         7lzTS+yCcwyXe4WfJElCMx77keeNVf6gvcFmEEwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/306] tools: bpftool: fix completion for "bpftool map update"
Date:   Wed, 27 Nov 2019 21:29:26 +0100
Message-Id: <20191127203123.650790329@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit fe8ecccc10b3adc071de05ca7af728ca1a4ac9aa ]

When trying to complete "bpftool map update" commands, the call to
printf would print an error message that would show on the command line
if no map is found to complete the command line.

Fix it by making sure we have map ids to complete the line with, before
we try to print something.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/bash-completion/bpftool | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 598066c401912..c2b6b2176f3b7 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -143,7 +143,7 @@ _bpftool_map_update_map_type()
     local type
     type=$(bpftool -jp map show $keyword $ref | \
         command sed -n 's/.*"type": "\(.*\)",$/\1/p')
-    printf $type
+    [[ -n $type ]] && printf $type
 }
 
 _bpftool_map_update_get_id()
-- 
2.20.1



