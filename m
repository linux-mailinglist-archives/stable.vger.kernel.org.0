Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD2810CC4F
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 16:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfK1P7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 10:59:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21169 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726633AbfK1P7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 10:59:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574956788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/QBHEanAnhJnmZ8pttrzUKSxHgn6TIpT2MQ/5Lg7YF8=;
        b=jRRlb39dHpMxdTcnOh2hZxfaXgpTNuIqEQlGYrngy+KpO9Gcs99HmSXjOO0OJhQ4EWFzmm
        gUaB/6thyTqQ+IAnEXJe4OuqncJ8OZpDQ3VOkAJnjDihyr1nwhIGRB8B+ZpfuTCWBkF5qz
        oLcpBg3ZAk76Xgbu3pa/jm/NWSHuK5c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-fUGNOxfQPFymgRa7B6uPPQ-1; Thu, 28 Nov 2019 10:59:46 -0500
Received: by mail-wm1-f70.google.com with SMTP id l11so3700188wmi.0
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 07:59:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vPUbXlh0ygv/oQuHSRuwxKMQNHDHgL0AUVPr6KUwCtg=;
        b=KeZeZT+bU3E+QLbfU4tnYk5FFeFxRqFCL0mE53W+JYBdzobmjCgBGajgXKpnrD2w8x
         xtBRwMbp5VRxNkKx1GViKE+VG6sJdZs1FcxTNKV1cSzuKJPn6RED+flGf1aF2X4CxTC/
         z6EL4RhX0NbqnX9SbPVXJg2ccgpql1Bv84c/t2lnfbUMs7KDrBUJv/9+FS7CI+T9a0r9
         TU4lzUvFzOqQxIYfzJ1sbvK5yKws4EBPel0jp6jF+f/E38jIOLv9AaSw5jyF6v1+F4GV
         aKNxpKFRielK+JxQeH1OBU0WwC/gccEprc+aaZj8sSMKtQHLE2hrLUmkKudpsLwLYeSh
         6zyA==
X-Gm-Message-State: APjAAAWwD84r8vscFivNGLHTUIrpFMQn83SD43zaY0WJtXFaZSPiqk2Q
        sKpJuNW2Q4zED6ZiFH1EIXghfdLbYktAf61yqaQoujzsqhnH4i5LeqolavCp3HEfzO1+hd74m8t
        GkZgHsklo1nvztexk
X-Received: by 2002:adf:e886:: with SMTP id d6mr43622020wrm.112.1574956785558;
        Thu, 28 Nov 2019 07:59:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqxCKrJiKteJ6JBXNs8YdU7/3P20wLIqyfhgjHIPW/eJswuIAtIwMpeBzbvXZ0lHsWjx+IxpIg==
X-Received: by 2002:adf:e886:: with SMTP id d6mr43622013wrm.112.1574956785377;
        Thu, 28 Nov 2019 07:59:45 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-212-96-48-140.catv.broadband.hu. [212.96.48.140])
        by smtp.gmail.com with ESMTPSA id 2sm23689474wrq.31.2019.11.28.07.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 07:59:44 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, Andrew Price <anprice@redhat.com>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 02/12] fs_parse: fix fs_param_v_optional handling
Date:   Thu, 28 Nov 2019 16:59:30 +0100
Message-Id: <20191128155940.17530-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191128155940.17530-1-mszeredi@redhat.com>
References: <20191128155940.17530-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-MC-Unique: fUGNOxfQPFymgRa7B6uPPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

String options always have parameters, hence the check for optional
parameter will never trigger.

Check for param type being a flag first (flag is the only type that does
not have a parameter) and report "Missing value" if the parameter is
mandatory.

Tested with gfs2's "quota" option, which is currently the only user of
fs_param_v_optional.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Andrew Price <anprice@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Fixes: 31d921c7fb96 ("vfs: Add configuration parser helpers")
Cc: <stable@vger.kernel.org> # v5.4
---
 fs/fs_parser.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fs_parser.c b/fs/fs_parser.c
index d1930adce68d..5d8833d71b37 100644
--- a/fs/fs_parser.c
+++ b/fs/fs_parser.c
@@ -127,13 +127,15 @@ int fs_parse(struct fs_context *fc,
 =09case fs_param_is_u64:
 =09case fs_param_is_enum:
 =09case fs_param_is_string:
-=09=09if (param->type !=3D fs_value_is_string)
-=09=09=09goto bad_value;
-=09=09if (!result->has_value) {
+=09=09if (param->type =3D=3D fs_value_is_flag) {
 =09=09=09if (p->flags & fs_param_v_optional)
 =09=09=09=09goto okay;
-=09=09=09goto bad_value;
+
+=09=09=09return invalf(fc, "%s: Missing value for '%s'",
+=09=09=09=09      desc->name, param->key);
 =09=09}
+=09=09if (param->type !=3D fs_value_is_string)
+=09=09=09goto bad_value;
 =09=09/* Fall through */
 =09default:
 =09=09break;
--=20
2.21.0

