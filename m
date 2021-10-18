Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E730431EA3
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhJROFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234669AbhJROAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC4E661A56;
        Mon, 18 Oct 2021 13:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564544;
        bh=ZtJ20s/9+j39b3SSz+vdhbHiPI4MdJdL8D2IJFg57Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPDJc5CkD8FSaihievEuQ67zgPDia+z8gdRJo01ju60m+aNSen4WZKf7kIhd9f+hB
         KTsX47kj3UaI0GWnAyigkdVdZWkUB6n5AxkZUfebdDzn3Af3cWT+PnpTZ+btE2MK7U
         r0aP+xyRvPymFlrSd/b6Ta3e9JB5s42nbq3jYjkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.14 129/151] drm/msm/submit: fix overflow check on 64-bit architectures
Date:   Mon, 18 Oct 2021 15:25:08 +0200
Message-Id: <20211018132344.859780737@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 95c58291ee709424557996891926a05a32c5b13a upstream.

The overflow check does causes a warning from clang-14 when 'sz' is a type
that is smaller than size_t:

drivers/gpu/drm/msm/msm_gem_submit.c:217:10: error: result of comparison of constant 18446744073709551615 with expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
                if (sz == SIZE_MAX) {

Change the type accordingly.

Fixes: 20224d715a88 ("drm/msm/submit: Move copy_from_user ahead of locking bos")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210927113632.3849987-1-arnd@kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -161,7 +161,8 @@ out:
 static int submit_lookup_cmds(struct msm_gem_submit *submit,
 		struct drm_msm_gem_submit *args, struct drm_file *file)
 {
-	unsigned i, sz;
+	unsigned i;
+	size_t sz;
 	int ret = 0;
 
 	for (i = 0; i < args->nr_cmds; i++) {


