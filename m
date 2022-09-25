Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D265E5E9221
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 12:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiIYKgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 06:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiIYKfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 06:35:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B5D63F2;
        Sun, 25 Sep 2022 03:35:45 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fv3so3929832pjb.0;
        Sun, 25 Sep 2022 03:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=MnQV08Nm5DUfn+ajbCUcj5NDJLfa2o8gGneNeea/dMc=;
        b=FC70Zv07OD85ToswH8mb+a4RJKd4bno7ocxgsGDXRzI+Hio5wH7+O8cOnY6S8WIsR9
         PMtiCvtsBQ+KKGITl1LNpeB1mT27/w32Ll+fZ45QDImLKFN6jMnt5JDlHpRUwT0BrxRB
         U/1H9oAN9k4BE3Jd/Rw3JFQvvC4A0ibMHmZEWAtLFvbTC/0xNj4TMNODZewVw+su6U4e
         MgaAG+S432Qsl3iMawtbtZREGpxXxK+uwtVVVMsFXDHkLBxIEf0UkUmSZDdukjgms888
         qJLGhMutVmERg3CdJip2gsaDPQD4OKMtC4D+e7+jlC7hSxpyf9Ws+vTGvCA23RCDvKD8
         5lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=MnQV08Nm5DUfn+ajbCUcj5NDJLfa2o8gGneNeea/dMc=;
        b=T5UDXTW528gJuihecg9kVvqo+Fy+NodMzVHPyl7ZMAvpMJPD2nhYuW3xA49i2Dr87r
         4cPm9+u1GV3H8b9YPg6uphhGB+JGzEM/HF4D1FHIYctC5Vb/YIcMlFHrVZfUMYpwYbpY
         V5Y9AJ7n4vSwdWZ/6y53AkYC/IbS3lqQRJPWvOK8NM4nJ/JQcXFLFvoQTw2kuSKAEHDx
         qOCzHJNz4wgkT4HEMRXHYPOjj7/N+baUqTJKNJV21RnKDflekboHKE7yEzN8uPnRy2v0
         e0mLGdvn+iqKRdfKFn1ZO5tR4ogj52tp0DIWkfH+cTJHqdzMGv70n2OHrr7Rl8xh5B24
         j0sw==
X-Gm-Message-State: ACrzQf2T1MWX+GzwwV2cLU7RZn5/xup8F6yIApObbA8p/EdktLXBfL+c
        npnToojtDmNpN/h0No86nAc=
X-Google-Smtp-Source: AMsMyM4FJlLbrI1Y1wD6HdZ7sLzhsR4IIX5LKXhQWaXDRUgSrn6uGdgXTblxMM/dThGj637p947mmA==
X-Received: by 2002:a17:90b:1d07:b0:203:6732:e280 with SMTP id on7-20020a17090b1d0700b002036732e280mr30116158pjb.172.1664102144646;
        Sun, 25 Sep 2022 03:35:44 -0700 (PDT)
Received: from ubuntu.localdomain ([117.176.186.252])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e80400b00179c81f6693sm3722183plg.264.2022.09.25.03.35.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Sep 2022 03:35:44 -0700 (PDT)
From:   wangyong <yongw.pur@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn,
        yongw.pur@gmail.com
Subject: [PATCH v2 stable-4.19 0/3] page_alloc: consider highatomic reserve in watermark fast backports to 4.19
Date:   Sun, 25 Sep 2022 03:35:26 -0700
Message-Id: <20220925103529.13716-1-yongw.pur@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <Yyn7MoSmV43Gxog4@kroah.com>
References: <Yyn7MoSmV43Gxog4@kroah.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here are the corresponding backports to 4.19.
And fix classzone_idx context differences causing patch merge conflicts.

Original commit IDS:
	3334a45 mm/page_alloc: use ac->high_zoneidx for classzone_idx
	f27ce0e page_alloc: consider highatomic reserve in watermark fast
	9282012 page_alloc: fix invalid watermark check on a negative value

Changes from v1:
- Add commit information of the original patches.

Jaewon Kim (2):
  page_alloc: consider highatomic reserve in watermark fast
  page_alloc: fix invalid watermark check on a negative value

Joonsoo Kim (1):
  mm/page_alloc: use ac->high_zoneidx for classzone_idx

 mm/internal.h   |  2 +-
 mm/page_alloc.c | 69 +++++++++++++++++++++++++++++++++------------------------
 2 files changed, 41 insertions(+), 30 deletions(-)

-- 
2.7.4
