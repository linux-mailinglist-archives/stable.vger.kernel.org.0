Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF55D518D13
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 21:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238614AbiECTWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238223AbiECTWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 15:22:30 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0EE3FBC2;
        Tue,  3 May 2022 12:18:54 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x33so31984911lfu.1;
        Tue, 03 May 2022 12:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9bc+0+EW4/MtA3VPCNmrCMbEtcsIX6zc6mk0YffK+XQ=;
        b=pt8TuWkpyhizyhHAeP7WwEJDda2SzwavZg/PQYYzrTW0rQjY4lGrO7hcWGKwo2HGR/
         cz0bJBYVfCNzdvZoAFMJTtPdWfgGv+kVD94YHmxf+kelGaN85iUhs1DcSpB+XFEdxeCg
         igrwdyoUTO3JSfB4h54KeQSvExm3Y51gIPgrFz++fIcR0kslzTdajTzi8cG6mChO38Fs
         Xtm2d82Ut1bMXrPItmQ6cxEY5hrEAXlpwrKp6qXX+Q2fDKKoFvc5DMIYaMTXwz2XIora
         CnMwXG8vQaqdW7EBLHCQLeQ/nY2slsqEHD/u2uYUQ+3ILINtxOO9bZHUds7SChs18AGS
         PM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9bc+0+EW4/MtA3VPCNmrCMbEtcsIX6zc6mk0YffK+XQ=;
        b=Qb8MEjItg7ct/7rZ5cKWMViEFZCuIzC4aNzKVg0DGLzaaPWjQAkN1Bwn/z7sybzldp
         FHG1qUckfqAHFwxSYouO+zINECUl8eT9kVu8H5uruLr2nU62QKq3RJuQM4CGVwXaKa58
         DwgBbMq+y6Oo3oqt5g5K4vBEKDThYRq3kue0c+M1IG8QmwPCWXabXOf96wxyUF39s7WO
         83IGH3kDy/GbSk4Aj30kEfxiwoQIxB5WguIol8o1H3N+BPBDdJr9HfAlnn2gNGickUa7
         QC/HWcH9vp6V4CkTo6XHuKssYIgeOyklFOlE70ZmbhVP/oeQGYNRBaLHp6vmPEz64j4B
         Qstw==
X-Gm-Message-State: AOAM533BiVlijQL8Zn+tjEcixQVniIkqvxIWoWW/QSXruDP8cLKeixh8
        RDALq+q7oEHKHQSFJkkUiL8MICku3iv+xw==
X-Google-Smtp-Source: ABdhPJwkDqUgq2ftaH4ubSRBwqOVOhMhqJQ5FP0r3KtgqS2KFXxfQhdAJ74e3vpjltfVFU9vBjfBlg==
X-Received: by 2002:a05:6512:3b81:b0:472:5e4e:19e0 with SMTP id g1-20020a0565123b8100b004725e4e19e0mr8952787lfv.426.1651605533113;
        Tue, 03 May 2022 12:18:53 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id w10-20020ac254aa000000b0047255d21194sm1013894lfk.195.2022.05.03.12.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 12:18:52 -0700 (PDT)
From:   "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To:     stable@vger.kernel.org
Cc:     RCU <rcu@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Neeraj Upadhyay <neeraj.iitr10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: [PATCH 0/2] RCU offloading vs scheduler latency(for 5.10 stable)
Date:   Tue,  3 May 2022 21:18:41 +0200
Message-Id: <20220503191843.155363-1-urezki@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This port is for 5.10 kernel. See the motivation and explanation in the cover
letter for the 5.15 port.

Frederic Weisbecker (2):
  rcu: [for 5.10 stable] Fix callbacks processing time limit retaining cond_resched()
  rcu: [for 5.10 stable] Apply callbacks processing time limit only on softirq

 kernel/rcu/tree.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

-- 
2.30.2

