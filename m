Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC102416CD
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 09:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgHKHBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 03:01:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31475 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728360AbgHKHBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 03:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597129278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=TEG2fDTMrT9CyNXx3j58WMIBzVoaSf9PoptkoEoE8fA=;
        b=fxy7bKRch+AtDqFCDMFZw1TB1p0a+nGTBvCV1OQ9SXj2DBjXBIFBCS708hpH9nSkmtEbcu
        8vOk7GnYvBI3AtAW2qz7QXI1vGF1r/nNo8ooyywgCpnm4/8l8lGP09Z/xTQX7mNuIEWioQ
        4cLRnhTOqBCV6Mq2/pWfJmgO2XtQ9LE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-VN9EaqggNl2GwEkv9REbCQ-1; Tue, 11 Aug 2020 03:01:14 -0400
X-MC-Unique: VN9EaqggNl2GwEkv9REbCQ-1
Received: by mail-pl1-f198.google.com with SMTP id s2so8398323plr.22
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 00:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TEG2fDTMrT9CyNXx3j58WMIBzVoaSf9PoptkoEoE8fA=;
        b=olfNGBzrXfXr4bWPqMNTr1gGrMPa3nXGS3P7fFsMLynyOuAWN8Qjk79TMWK1vwZf1d
         Xl3y6rNZZjbtdro1GZbLlO0EzDBW5Ufq33NhfpTzMfb9gdDeIdT4Xia/mjgT2nrWc5/j
         o1NdBEUZWecGp5I8Ut9bRrHUxHqWil/mwXHdRVWKDjqgb4KzkDYBXxFVotjhMjz/0TvC
         6l202cCNoHYThV8YTFWKdeeXs8aFeGmCIIOBDcge9szP//n54hUBMj8eglQXHrTauEJU
         3U4tZ0vBOVrvLp0VU205NLgutoZ4KiVapkA1EMrd7DHUiLgMbTGVz1TeUnFY2MgC1yrt
         aU/Q==
X-Gm-Message-State: AOAM533cp4YhcSQpm4TmJYqvsuWHxR+hykok/1Ts9vUoZ7tZBr1LriCb
        uCVHu/dr2Wa5/5AhvAbYAefsuwBKHYzDO5bERUtBOTXdxEp30z5Dc28NyPO72zUsDHQt0HvGZyu
        34xWDJexYjW+qyFoe
X-Received: by 2002:a17:902:b417:: with SMTP id x23mr25968263plr.231.1597129273864;
        Tue, 11 Aug 2020 00:01:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/PxAh0tVI6Za7raz5oYvg/ytWr1qauzk4b41fv1H/5Mxa/CRU1ZHv8AgkFi0j4qdCop3bmw==
X-Received: by 2002:a17:902:b417:: with SMTP id x23mr25968217plr.231.1597129272976;
        Tue, 11 Aug 2020 00:01:12 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y19sm24098541pfn.77.2020.08.11.00.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 00:01:12 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-erofs@lists.ozlabs.org, Chao Yu <yuchao0@huawei.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Chao Yu <chao@kernel.org>,
        Hongyu Jin <hongyu.jin@unisoc.com>,
        Gao Xiang <hsiangkao@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] erofs: avoid duplicated permission check for "trusted." xattrs
Date:   Tue, 11 Aug 2020 15:00:20 +0800
Message-Id: <20200811070020.6339-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Don't recheck it since xattr_permission() already
checks CAP_SYS_ADMIN capability.

Just follow 5d3ce4f70172 ("f2fs: avoid duplicated permission check for "trusted." xattrs")

Reported-by: Hongyu Jin <hongyu.jin@unisoc.com>
[ Gao Xiang: since it could cause some complex Android overlay
  permission issue as well on android-5.4+, so it'd be better to
  backport to 5.4+ rather than pure cleanup on mainline. ]
Cc: <stable@vger.kernel.org> # 5.4+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
related commit:
https://android-review.googlesource.com/c/kernel/common/+/1121623/6/fs/xattr.c#b284

 fs/erofs/xattr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index 87e437e7b34f..f86e3247febc 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -473,8 +473,6 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
 			return -EOPNOTSUPP;
 		break;
 	case EROFS_XATTR_INDEX_TRUSTED:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
 		break;
 	case EROFS_XATTR_INDEX_SECURITY:
 		break;
-- 
2.18.1

