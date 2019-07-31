Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642F37C879
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 18:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfGaQWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 12:22:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36095 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaQWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 12:22:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so70437872wrs.3
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 09:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fMsIsafJcgydqieWtyKK37V7eK4LkebHJjWC8cS/T/c=;
        b=lrI/WQG7zcEbxu87Ge/KhadS8/uzovKj4UxBeqaVQeeh/IJ6jb3P643H1Mjg8TUypR
         iz6C2ioCKKiAguMR5M2Uue2OVu85XP+jv0N+hgAKuemRZFVXmynMumZo98x3LP6JpwQt
         mkfBooJZ3wchfoHTuvNtXFJq9j8Fwt7cYiXr9RqXyUjStPA4z+ex0pqJ2gWnT6n/AiDp
         FqNIKsenIcbbYFFNACv86D4ne3STNFKe/Sk1b/JQhun5jsEI68Estd5Do6Bo2SOzWqOx
         p8uu07fe3K01R7/0m9eismadng56pWsMD7FQE74aWr3l84HtWiK7qvMfwGmFPE4g0Wop
         CxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fMsIsafJcgydqieWtyKK37V7eK4LkebHJjWC8cS/T/c=;
        b=q91mfWH7slgeQoV6bFSRABPUU+BWptxhMA+L3aVGCqJNFcKjVjCzozVUqAgkUwNAqp
         izb/7Fj2w3qnNdowUr3E4g7zLWvhpE0ra6V8imVg4rqlBUKDARS9IlJXsF4Es48tfiRb
         Wtx5JNTVqcgNHvJlneC3jw2BQ91jaRu0xrKcSxFgbM1ZZ47dMWLtHyZeIdJrwDAQhSXQ
         VjIqvjJUqyJsrNZiD94POx7uJwHpweLpTdO+ahbx4rfO1TSurJ3iePExO/Be1t5EUewT
         z46ed/VFRfxkLYgS5rC0+w+1klA6ZftmaxtR+IXGUJ70ADQYM3j2khfTopJ8j9k7eFGg
         kt3g==
X-Gm-Message-State: APjAAAUUSG2ECFXnzMAAbj8SnALrN0sNGOVtaDEYNfXB0X696vQI2rv+
        i3KEes5/17dIbvLiVKVY7HkybiBOsf6vH7J2J62Di19KZIJChrKgj8K4v+49K8yBpnsY/lNIgRV
        egExAEMzH0fhXeHh161QJB2PlRxDiZkh4NIN8P+dLXNZ6CN37gFFqERpo/Qm/6hesfZZ3uLH+xz
        JcR++O9PEtp8ycrJv6Kg==
X-Google-Smtp-Source: APXvYqwmyHO/G5Qdz7Loyy4J0DUGudZgyuCTSX2O9MI62Ekd+VoR+lyIQy0vaNv8nJDQCyBNI7ETyw==
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr140203821wrs.93.1564590142064;
        Wed, 31 Jul 2019 09:22:22 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9sm114557717wrp.54.2019.07.31.09.22.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 09:22:21 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     0x7f454c46@gmail.com, Dmitry Safonov <dima@arista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org
Subject: [PATCH-4.19-stable 0/2] iommu/vt-d: queue_iova() boot crash backport
Date:   Wed, 31 Jul 2019 17:22:18 +0100
Message-Id: <20190731162220.24364-1-dima@arista.com>
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

