Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB28544DFF
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 15:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245755AbiFINpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 09:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245750AbiFINpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 09:45:18 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBECB4CD41;
        Thu,  9 Jun 2022 06:45:17 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w27so31216761edl.7;
        Thu, 09 Jun 2022 06:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8qG3170smLK/mqTRiF4ohYCGG+OvAJcbZb/OP7QyBbg=;
        b=qyYdZOzTF42pcHg8bhW7Dq3E70uOa+0wmRmvtCrY4kK9vZdsL0FkR73X7P4dRA+yAM
         pN5AtVFsy9Ytfv8XQB+HqaCMUD7mjr9Q5YnqcN4VPIlYNiuETUPDQA7YPsy2an5v10jK
         BlW0Wg1TZYIKfP3dl3aQPWu3Eoaqtk2PmhfJXAjsMJi3XrUJZI8QvR40D2CR+MQlULvh
         ijrOfWbYHnmGwuhOakEXIPnADwhlFejzjtzOmqGS34CcLp9FvP2XN1W59xKcR4WazLGG
         NrWMJC19k5oI1jh1MYpH1ononAt02ooWL4elsUGNw1cqerbvYeLr5Cey9AIZ5RfmfMV+
         TPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8qG3170smLK/mqTRiF4ohYCGG+OvAJcbZb/OP7QyBbg=;
        b=p+uwyvrTMiXOSzRDfpf3sSgZuBm1lhkdzU10YrW5DXypvKhK6x9MgODiUgaWcGhxkK
         bDgPcfTNBqFd+ZOpjbaq4ReBPbnkS5PQZ5FJC9nqM1VaP6f/bIrSF7OCHD7kVpc0esHN
         8Uz2RI15wNeRfvvLmGf3We6jVh0qtpn/2XPWHnA55PjE15Bpg9aFDo9ZjgT20/v+C9qu
         mx8ZX3FPGnUQWdxhaz6bdIz5vuChlIziZC41mMKUuZHpG69xBQ8Rne47Qhs1FVV+u/PL
         nVrenmo5Sp90I9+h5E9gxkkOWtHm6thWtbZ35/RjczGNMhO3siB6DuGT7nl3ipFQGMVe
         jFQg==
X-Gm-Message-State: AOAM532+IMJlwHCY5JBrslc0ghU73DZ6OQxqKbyRECVT/CH2FnpCIumK
        Zensr3mkai7MW6jyTbHevUk=
X-Google-Smtp-Source: ABdhPJys76xgvlpLBZnKpA5TTL442Q8OD6kv2jsSOff1omKrv1aqV2zNbB/saHrpufJfgPbrJhdSqg==
X-Received: by 2002:a05:6402:c1:b0:42a:b8a5:8d5e with SMTP id i1-20020a05640200c100b0042ab8a58d5emr45616324edu.266.1654782316300;
        Thu, 09 Jun 2022 06:45:16 -0700 (PDT)
Received: from PCBABN.skidata.net ([2001:67c:2330:2014:7a45:c4ff:fe0f:c570])
        by smtp.gmail.com with ESMTPSA id r11-20020aa7d58b000000b0042df0c7deccsm14505041edq.78.2022.06.09.06.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 06:45:15 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     V.Sethi@nxp.com, festevam@denx.de, festevam@gmail.com,
        gaurav.jain@nxp.com, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        l.stach@pengutronix.de, robert.hancock@calian.com,
        petr.benes@ysoft.com, michal.vokac@ysoft.com
Subject: Re: [PATCH v5] crypto: caam - fix i.MX6SX entropy delay value
Date:   Thu,  9 Jun 2022 15:45:04 +0200
Message-Id: <20220609134504.732905-1-bbara93@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <Ymt8ioIe0UU1NskR@gondor.apana.org.au>
References: <Ymt8ioIe0UU1NskR@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

I found an older discussion on the same topic,
where it is mentioned that the same problem also occurs on imx6dl, imx6d and imx6s:

https://linuxlists.cc/l/4/linux-crypto/t/3843436/caam_rng_trouble#post4282922

I have also observed the problem on an imx6dl, running a 5.10.112 kernel.

Therefore, the problem might persist for the other variants.

BR
BB

