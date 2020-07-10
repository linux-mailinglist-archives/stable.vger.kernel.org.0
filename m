Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1066B21B455
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 13:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGJL6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 07:58:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21543 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726921AbgGJL6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 07:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594382292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nAOXmVWgoczSuOlfXxBAYA4BAGAkdUAmIONdRmDi7fU=;
        b=PMrWyJyVkkPNOoYglXGBqgq38slyr1M6XgD6o1bVtWBQKADIkmc/ZMAXujoR/rQs1ZN4/3
        iGL4EYFk5wIiDM0oXqUIsyryvJ7w4+ri2C/Ma1qMF8bwO7gJTrgjvc0mhGZgTn8mMCrXHY
        wPJrd5VlkIqtf5bc3dS9p0t4LaYPPEM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-k7VtrdnCOe6wvsggYynLuw-1; Fri, 10 Jul 2020 07:58:10 -0400
X-MC-Unique: k7VtrdnCOe6wvsggYynLuw-1
Received: by mail-ej1-f70.google.com with SMTP id q9so6163105ejr.21
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 04:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nAOXmVWgoczSuOlfXxBAYA4BAGAkdUAmIONdRmDi7fU=;
        b=WuE5DA/vOkRH63bpZ2jFjMvlMA55D0hQ4pCocEa372kj8nawvc6Z5RuaxNBeIwMEYt
         7LLov58r/6HMus65H0DrHKUKMr9TlXYYn8JBZtXZe3bFFgVAxnRlVVytjlbzHEe+usSd
         5vg1l4AqN3HrdADnQ2RXjLhG/f2CYYIYjnof24+qUdJZTQ581rdLwpprbG4Q8T434J6k
         zF50aY3ZPw6EQ9VFTBqu0A1EB6mYmY9uht9YogfWC9mMxImPq8CsLvTGZ8M+rEgIacky
         eRzJRDbSwYkF+MBskrbZUCpfQGL2dUsMQYg7EcgtcNm6W0PxvMG2N6YHacr4+K/kkCmq
         fJOQ==
X-Gm-Message-State: AOAM530on3xVBcQauAmRxKfBkTRc9xSKslbVY0Mzd3BYeZCheTJNTw4Y
        4/DXq2+T0lhkAlKAEzBslbNFko5iDmdHjoOrgSaLjktxRDkYCPWGqO+tEpKzQ48TsIj5Y2XT8O3
        WN3VDhqMMY7cnon0M
X-Received: by 2002:a17:906:cd2:: with SMTP id l18mr63295732ejh.18.1594382288907;
        Fri, 10 Jul 2020 04:58:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTEnQRlfNnkfPFFldvYN1w1+dgGHdWpPHvYgpL+8iT4dpCcLKqV3BiLsKe2MEEqovgVDMfZQ==
X-Received: by 2002:a17:906:cd2:: with SMTP id l18mr63295724ejh.18.1594382288749;
        Fri, 10 Jul 2020 04:58:08 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-212-96-48-140.catv.broadband.hu. [212.96.48.140])
        by smtp.gmail.com with ESMTPSA id a8sm3536951ejp.51.2020.07.10.04.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 04:58:08 -0700 (PDT)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Stefan Priebe <s.priebe@profihost.ag>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 2/3] fuse: ignore 'data' argument of mount(..., MS_REMOUNT)
Date:   Fri, 10 Jul 2020 13:58:04 +0200
Message-Id: <20200710115805.4478-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200710115805.4478-1-mszeredi@redhat.com>
References: <20200710115805.4478-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The command

  mount -o remount -o unknownoption /mnt/fuse

succeeds on kernel versions prior to v5.4 and fails on kernel version at or
after.  This is because fuse_parse_param() rejects any unrecognised options
in case of FS_CONTEXT_FOR_RECONFIGURE, just as for FS_CONTEXT_FOR_MOUNT.

This causes a regression in case the fuse filesystem is in fstab, since
remount sends all options found there to the kernel; even ones that are
meant for the initial mount and are consumed by the userspace fuse server.

Fix this by ignoring mount options, just as fuse_remount_fs() did prior to
the conversion to the new API.

Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Fixes: c30da2e981a7 ("fuse: convert to use the new mount API")
Cc: <stable@vger.kernel.org> # v5.4
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index be39dff57c28..ba201bf5ffad 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -477,6 +477,13 @@ static int fuse_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	struct fuse_fs_context *ctx = fc->fs_private;
 	int opt;
 
+	/*
+	 * Ignore options coming from mount(MS_REMOUNT) for backward
+	 * compatibility.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE)
+		return 0;
+
 	opt = fs_parse(fc, fuse_fs_parameters, param, &result);
 	if (opt < 0)
 		return opt;
-- 
2.21.1

