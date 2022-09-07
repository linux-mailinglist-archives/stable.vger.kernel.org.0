Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13FE5B021D
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 12:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiIGKwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 06:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIGKwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 06:52:08 -0400
X-Greylist: delayed 307 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Sep 2022 03:52:07 PDT
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B2481B26
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 03:52:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 9652C9C0A18;
        Wed,  7 Sep 2022 06:46:58 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Z7WzVSQaS_S8; Wed,  7 Sep 2022 06:46:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 1F6E99C098F;
        Wed,  7 Sep 2022 06:46:58 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 1F6E99C098F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1662547618; bh=fNhqV3ZMR3bzxn/7YR1APDHeqTvHYdUacsEsMOBAyFc=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=T3ApHo+N6sFHfeDTyriBQCs1Xg/kKsi/6jctiswWF7iDOiHRgBj+YukSd03WTUQ4l
         RFNT5leQKKmqIQlCBOYtxjEQxAwQLZpR8dGhmGsLjowMQHKVljkQK+x/YbJu36KxjW
         JOAjRap+GeqqpYokWL1p5I8qvS69N1qR5vhITHcSaGtJ8+nC5zbHuFTpwIZcIus5ov
         yT8c3//yVhwP8qGAtqqJp2ZF/94S1ICdIIv91Tb+IABgKVIaqFTfK93do/MDYLDdXC
         gNjkaMu8BeJmzs1uuY3OEw/YV4A7ocWYLFnLsTIloipcSqymau+HlmrxCnOYOl4KIa
         JtKfqk3uneVSw==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id af-THVrSsfYn; Wed,  7 Sep 2022 06:46:58 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (abordeaux-655-1-154-138.w92-162.abo.wanadoo.fr [92.162.199.138])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 6739F9C05B6;
        Wed,  7 Sep 2022 06:46:57 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, andrew@lunn.ch
Subject: [PATCH v3 0/2] net: dp83822: backport fix interrupt floods
Date:   Wed,  7 Sep 2022 12:45:57 +0200
Message-Id: <20220907104558.256807-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports the following fixes from 5.10 to 5.4.
This backport should also apply to 4.19.

A git conflict was solved involving DP83822_ANEG_COMPLETE_INT_EN which wa=
s moved
to a conditional in 5.10.

Original commit IDs:
c96614eeab663646f57f67aa591e015abd8bd0ba net: dp83822: disable false carr=
ier interrupt
0e597e2affb90d6ea48df6890d882924acf71e19 net: dp83822: disable rx error i=
nterrupt


