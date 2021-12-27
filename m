Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62CD47FFDD
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239367AbhL0Pl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39842 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239632AbhL0PkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 198BC6106D;
        Mon, 27 Dec 2021 15:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0105BC36AE7;
        Mon, 27 Dec 2021 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619616;
        bh=mp3n+iVQd285+3UVm2nM1DTFwgje/X5ICcZhhASQ554=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnJCw57gA2EgK2YuX4y01RS6Ef84JN0WHdh5ljE7DgOiVCalY2lbO2dKY8HoCVKW8
         1UIFMpDIB7M3zPmAYOyiKhr3cdLYeomdZgV4seKZq6J0Qg7XbReD5hQlNbRT2VMJAB
         HDW+dGfxQU3QbBWgEryh5wM3Dkm8epcDxuQp3fzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 010/128] PM: sleep: Fix error handling in dpm_prepare()
Date:   Mon, 27 Dec 2021 16:29:45 +0100
Message-Id: <20211227151331.848644139@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 544e737dea5ad1a457f25dbddf68761ff25e028b upstream.

Commit 2aa36604e824 ("PM: sleep: Avoid calling put_device() under
dpm_list_mtx") forgot to update the while () loop termination
condition to also break the loop if error is nonzero, which
causes the loop to become infinite if device_prepare() returns
an error for one device.

Add the missing !error check.

Fixes: 2aa36604e824 ("PM: sleep: Avoid calling put_device() under dpm_list_mtx")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1906,7 +1906,7 @@ int dpm_prepare(pm_message_t state)
 	device_block_probing();
 
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_list)) {
+	while (!list_empty(&dpm_list) && !error) {
 		struct device *dev = to_device(dpm_list.next);
 
 		get_device(dev);


