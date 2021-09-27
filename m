Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2203F419B60
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbhI0RRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236983AbhI0RPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:15:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC9CB611C7;
        Mon, 27 Sep 2021 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762677;
        bh=xmOji4utjG5jvt7UVZqdv0njldLlmPSOUsCp11rYo2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iy8Ug1VcVpWszA5ucVz7xQBuQfTRScsYMGM44aJmODlnoO/jQL2LNUkVcQgFA0jlk
         J/+wN0y7ggnnwv8VZwfnSGlCtWOc3ug44d3MS1du4cmVqRGedhZkrY0a6SwANzPJsH
         wSui7CvqhzShf14hi4SXsQAOsa8EOnpEM43aCFi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.14 011/162] cifs: Fix soft lockup during fsstress
Date:   Mon, 27 Sep 2021 19:00:57 +0200
Message-Id: <20210927170233.841143414@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohith Surabattula <rohiths@microsoft.com>

commit 71826b068884050d5fdd37fda857ba1539c513d3 upstream.

Below traces are observed during fsstress and system got hung.
[  130.698396] watchdog: BUG: soft lockup - CPU#6 stuck for 26s!

Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -736,7 +736,7 @@ cifs_close_deferred_file(struct cifsInod
 			if (cancel_delayed_work(&cfile->deferred)) {
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
-					continue;
+					break;
 				tmp_list->cfile = cfile;
 				list_add_tail(&tmp_list->list, &file_head);
 			}
@@ -767,7 +767,7 @@ cifs_close_all_deferred_files(struct cif
 			if (cancel_delayed_work(&cfile->deferred)) {
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
-					continue;
+					break;
 				tmp_list->cfile = cfile;
 				list_add_tail(&tmp_list->list, &file_head);
 			}


