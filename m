Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBAF311447
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhBEWCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232850AbhBEOyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEAC9650C3;
        Fri,  5 Feb 2021 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534493;
        bh=uzQETzjw8nT8iksAVQnNxCTqHD4pn5w/R5OubRmSggc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5rDOUWSUOMCF99MW3zqXOmkso6LGLKr/E6EclZxlnR/zAb/Pgbbc7Fd2KJDgWefi
         vO48G2ZO+aT47FsaTZiJJqtHK7q7d2q+GxSaGV/+P22BPfD43icsgyE+PthWGYDyiP
         hrGn2xsH1Xr2NbBRd2Y6kUykE4kjyBqvQLz56jUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 06/15] base: core: Remove WARN_ON from link dependencies check
Date:   Fri,  5 Feb 2021 15:08:51 +0100
Message-Id: <20210205140649.986802207@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.733510103@linuxfoundation.org>
References: <20210205140649.733510103@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

commit e16f4f3e0b7daecd48d4f944ab4147c1a6cb16a8 upstream

In some cases the link between between customer and supplier
already exist, for example when a device use its parent as a supplier.
Do not warn about already existing dependencies because device_link_add()
takes care of this case.

Link: http://lkml.kernel.org/r/20180709111753eucas1p1f32e66fb2f7ea3216097cd72a132355d~-rzycA5Rg0378203782eucas1p1C@eucas1p1.samsung.com

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -109,7 +109,7 @@ static int device_is_dependent(struct de
 	struct device_link *link;
 	int ret;
 
-	if (WARN_ON(dev == target))
+	if (dev == target)
 		return 1;
 
 	ret = device_for_each_child(dev, target, device_is_dependent);
@@ -117,7 +117,7 @@ static int device_is_dependent(struct de
 		return ret;
 
 	list_for_each_entry(link, &dev->links.consumers, s_node) {
-		if (WARN_ON(link->consumer == target))
+		if (link->consumer == target)
 			return 1;
 
 		ret = device_is_dependent(link->consumer, target);


