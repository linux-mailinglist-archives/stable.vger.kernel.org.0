Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D095B7C886
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 18:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfGaQXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 12:23:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36472 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaQXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 12:23:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id g67so56280941wme.1
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 09:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0wYUbEYCCym2GG5RcSPUCX+mSupUTzw5PRJT+NcA3C4=;
        b=c49vK9WljD2alSugRVvLlrIpIQTwBkUjKcKwcmlmWlddUEeY4KOdRW50it6RdWdI0O
         hpBTKP/9JjJwkgaJ2VLpSU2iZEHq2I+INh/RMXyO/UKw3D0/cCRfNrWULJ9sYkahL6lM
         ZzpThU1yIZo93H2YbHEolXi0Qbz3TUh4YeKc9crEnmdtRJCYF8h/q0wB2R2fN2DWf+/F
         i4Ge2O76uENTjUz52D2tdFa6UzIIMZx3xggSKTupp6R5otKR/f7qIuZ0lI4pMKLqzCqn
         adFoe5tpUSS7ZNzbZwhriwVirmtcmDAGa4V8rZckhGtPd5yuU6kbQ3Ba7DFAs2LI9Art
         18CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0wYUbEYCCym2GG5RcSPUCX+mSupUTzw5PRJT+NcA3C4=;
        b=V5AMR2G+XuzFKt77boRy85h9/gJDpGcIsWObbx0FXUO5ACjtcao4RBMDvQgrL7Rmbr
         ctz3jI2sii+jr8239XYzk3cAErWX5n6W9Qm7bwpp908OV79Cn/j7fOJOFuqguSMTIae4
         IFb+IiPMLVAogGo7r/Pw5qdRAkf2kPlIU/LNyB2rcXhSEd2ncFwQn0g7rE6YRDDAqiO5
         YimsADNN9g8cHBpHZnEb3uwkt5MmVmYqbIxQZTuCpyku7Y0TeFuzSMfIO7ALAgzuSwxb
         +8kV41mj1qg0DRU9PKq6LWzIQItatjKgpSbcBJCjJdrb2IlL5z+MTeEbdP5NFu24SjxC
         xCJQ==
X-Gm-Message-State: APjAAAXYjP8r1/JK2Tm1sVEhBIJI7jEshpbg4xijNLUlL/BFFVM8H5bP
        b8DnlKK7/c3GUs7ydBiDFgGUE54oMprJzPF8QEl3bZJATDKmQIpIN7/65ibPOHbNpP93fBLtAIj
        SflEK1ZXwpAnicTwjFlBp3CzZy63fVUrJ6nIVxJYmMqFertPN7uSioTDS+OKxoSFU3PMKtlwAzc
        o94WlUsp9U51HcLYnHiw==
X-Google-Smtp-Source: APXvYqwGzrRC4B4woWM6sGbK2nyczq6FciaPt62SyG/Zw7Fg/put55jM4d6qO9Qll74/TI15Htyx2g==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr114343485wmh.55.1564590203627;
        Wed, 31 Jul 2019 09:23:23 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id c3sm75530382wrx.19.2019.07.31.09.23.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 09:23:23 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     0x7f454c46@gmail.com, Dmitry Safonov <dima@arista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org
Subject: [PATCH-4.14-stable 0/2] iommu/vt-d: queue_iova() boot crash backport
Date:   Wed, 31 Jul 2019 17:23:19 +0100
Message-Id: <20190731162321.24607-1-dima@arista.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CLOUD-SEC-AV-Info: arista,google_mail,monitor
X-CLOUD-SEC-AV-Sent: true
X-Gm-Spam: 0
X-Gm-Phishy: 0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport commits from master that fix boot failure on some intel
machines.

I have only boot tested this in a VM. Functional testing for v4.14 is
out of my scope as patches differ only on a trivial conflict from v4.19,
where I discovered/debugged the issue. While testing v4.14 stable on
affected nodes would require porting some other [local] patches,
which is out of my timelimit for the backport.

Hopefully, that's fine.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Lu Baolu <baolu.lu@linux.intel.com>

Dmitry Safonov (1):
  iommu/vt-d: Don't queue_iova() if there is no flush queue

Joerg Roedel (1):
  iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA

 drivers/iommu/intel-iommu.c |  2 +-
 drivers/iommu/iova.c        | 18 ++++++++++++++----
 include/linux/iova.h        |  6 ++++++
 3 files changed, 21 insertions(+), 5 deletions(-)

-- 
2.22.0

