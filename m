Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F3D39E80E
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhFGULU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhFGULS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 16:11:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A777EC061574
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 13:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Tt2HEbpzfGi4/z5EgGkVvU0DQ5DWh5NKKlSlZVlLNRQ=; b=rP7swNITyvr/hOvpPweqJ33Z1m
        PAc/XERpgiley8NDYCql5qZ92lCwgs1S6E3DYLlTIBE5g1m1EiJn2xOnM9p5crOkzfJm2OZFUmHSp
        oRuwKNe9odVLsg+yUNTIRQQ+gi8mA9vsICd4R7AY4Pp8nw/X+ZngQEnz+1cXCVGEj13Rbcfw2JEOG
        v5RLi39CEFzcQwYmpOYl23z5eQ7uA3NJv1QH/mve8BfM/12CGQM8f6eQwlGOYAkqW/MSDzgMdHU4Z
        dW2X70aevj8Z9kmkZbObrHgz7TeURBhX4bcVXV4FTHGmZPuPbkukE72fiV+9NbNTRTUlyuAY/Jo81
        bWsM1Olg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqLYF-00GCKf-4z; Mon, 07 Jun 2021 20:08:56 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [5.4 PATCH 0/4] Fix a CONFIG_READ_ONLY_THP_FOR_FS bug
Date:   Mon,  7 Jun 2021 21:08:41 +0100
Message-Id: <20210607200845.3860579-1-willy@infradead.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This experimental feature has had a few bugs, but it has enough of
a performance effect that customers are actually asking for it to be
enabled.  So we should apply this upstream bugfix that needs a little
massaging to backport.  The first three patches enable the fix in the
fourth patch.  I've run the XArray test-suite after applying these
patches, and it continues to pass.

Matthew Wilcox (Oracle) (4):
  mm: add thp_order
  XArray: add xa_get_order
  XArray: add xas_split
  mm/filemap: fix storing to a THP shadow entry

 Documentation/core-api/xarray.rst |  16 ++-
 include/linux/huge_mm.h           |  19 +++
 include/linux/xarray.h            |  22 ++++
 lib/test_xarray.c                 |  65 ++++++++++
 lib/xarray.c                      | 208 ++++++++++++++++++++++++++++--
 mm/filemap.c                      |  37 ++++--
 6 files changed, 342 insertions(+), 25 deletions(-)

-- 
2.30.2

