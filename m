Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F9A3962F2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhEaPCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234135AbhEaPAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 11:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19A256135B;
        Mon, 31 May 2021 14:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622470409;
        bh=9xnYlClt5Apq64n3ylonKhCI9TdtrXuT3tANmzhMvxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVFDxX631P8Cfc83sHs+e3BD6/WMdx8PdBfJ+n+Z9XR/Vx4JlrytDGroHfdwK/ZeV
         dKYa2VhqP4a/GqGeZJ1HkCLKrY+K1R37VTEC2oJBkThAz5fUZdE6b0s/hfyWtyzOQ2
         NV09FzTTlBcePoi07De1REGPiHx9hijkRZidz+kQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.9 31/66] NFSv4: Fix v4.0/v4.1 SEEK_DATA return -ENOTSUPP when set NFS_V4_2 config
Date:   Mon, 31 May 2021 15:14:04 +0200
Message-Id: <20210531130637.252360425@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit e67afa7ee4a59584d7253e45d7f63b9528819a13 upstream.

Since commit bdcc2cd14e4e ("NFSv4.2: handle NFS-specific llseek errors"),
nfs42_proc_llseek would return -EOPNOTSUPP rather than -ENOTSUPP when
SEEK_DATA on NFSv4.0/v4.1.

This will lead xfstests generic/285 not run on NFSv4.0/v4.1 when set the
CONFIG_NFS_V4_2, rather than run failed.

Fixes: bdcc2cd14e4e ("NFSv4.2: handle NFS-specific llseek errors")
Cc: <stable.vger.kernel.org> # 4.2
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -147,7 +147,7 @@ static loff_t nfs4_file_llseek(struct fi
 	case SEEK_HOLE:
 	case SEEK_DATA:
 		ret = nfs42_proc_llseek(filep, offset, whence);
-		if (ret != -ENOTSUPP)
+		if (ret != -EOPNOTSUPP)
 			return ret;
 	default:
 		return nfs_file_llseek(filep, offset, whence);


