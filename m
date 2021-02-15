Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C58731BD24
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhBOPkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:40:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhBOPgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:36:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B6DB64ED7;
        Mon, 15 Feb 2021 15:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403154;
        bh=LnPdiWxmYswvudyCPnAmeCke0qm0uWWt2RBavlq4lGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srq2uu2yQzRpu4EVOyzQMWVZtDgAVLfazGvsKUA7xOYLiSTWDhndJR0CgLi0dSe4C
         dIIWTbkigzmHft6jC5HLCtGC68GVSjLXe6O1+Do4esXYk7LlXAZZCBG0HHRArRMW/d
         XsmIESq3/wIki/Ks7r/1oLoNmzIKTcj89jpw0eVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhou <chenzhou10@huawei.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/104] cgroup-v1: add disabled controller check in cgroup1_parse_param()
Date:   Mon, 15 Feb 2021 16:27:02 +0100
Message-Id: <20210215152721.061913782@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 61e960b07b637f0295308ad91268501d744c21b5 ]

When mounting a cgroup hierarchy with disabled controller in cgroup v1,
all available controllers will be attached.
For example, boot with cgroup_no_v1=cpu or cgroup_disable=cpu, and then
mount with "mount -t cgroup -ocpu cpu /sys/fs/cgroup/cpu", then all
enabled controllers will be attached except cpu.

Fix this by adding disabled controller check in cgroup1_parse_param().
If the specified controller is disabled, just return error with information
"Disabled controller xx" rather than attaching all the other enabled
controllers.

Fixes: f5dfb5315d34 ("cgroup: take options parsing into ->parse_monolithic()")
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Reviewed-by: Zefan Li <lizefan.x@bytedance.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup-v1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 32596fdbcd5b8..a5751784ad740 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -917,6 +917,9 @@ int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		for_each_subsys(ss, i) {
 			if (strcmp(param->key, ss->legacy_name))
 				continue;
+			if (!cgroup_ssid_enabled(i) || cgroup1_ssid_disabled(i))
+				return invalfc(fc, "Disabled controller '%s'",
+					       param->key);
 			ctx->subsys_mask |= (1 << i);
 			return 0;
 		}
-- 
2.27.0



