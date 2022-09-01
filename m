Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82765A949F
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiIAK3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiIAK30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:29:26 -0400
X-Greylist: delayed 108716 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Sep 2022 03:29:23 PDT
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA275D25E7
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 03:29:23 -0700 (PDT)
Received: from mail-auth.avm.de (unknown [IPv6:2001:bf0:244:244::71])
        by mail.avm.de (Postfix) with ESMTPS;
        Thu,  1 Sep 2022 12:29:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
        t=1662028160; bh=pCVsKFB9GopN8z6OOChumzZDeRaBlXHqNl1/bAWLHVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qRsAbiNfQoh//1U6JfSbh+Dcq4Uuw1mSDFxzCsqE+NK3hXbLyyoGCr0Kb55k9a+vw
         xJKiWqli7Riv5nrE7lk55a0FZh5vb1O2fAsYrOltJn7LGG2SR6VdS/N0sSKx7CFsPd
         0yRKMBuALl944sdibVJAukRLuxbQ9OzadW1f6uuU=
Received: from buildd.core.avm.de (buildd-sv-01.avm.de [172.16.0.225])
        by mail-auth.avm.de (Postfix) with ESMTPA id 46DD0803D8;
        Thu,  1 Sep 2022 12:29:21 +0200 (CEST)
Received: by buildd.core.avm.de (Postfix, from userid 1000)
        id 3CF18181D55; Thu,  1 Sep 2022 12:29:21 +0200 (CEST)
Date:   Thu, 1 Sep 2022 12:29:21 +0200
From:   Nicolas Schier <n.schier@avm.de>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 5.4] kbuild: Fix include path in scripts/Makefile.modpost
Message-ID: <YxCJgQ+Dvu1FbN4x@buildd.core.avm.de>
References: <20220831041724.1493230-1-n.schier@avm.de>
 <YxCHiTdsFI4WRF7F@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YxCHiTdsFI4WRF7F@kroah.com>
X-purgate-ID: 149429::1662028160-AD71B03E-1C8CDAD1/0/0
X-purgate-type: clean
X-purgate-size: 2114
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 12:20:57PM +0200, Greg KH wrote:
> On Wed, Aug 31, 2022 at 06:17:24AM +0200, Nicolas Schier wrote:
> > From: Jing Leng <jleng@ambarella.com>
> > 
> > commit 23a0cb8e3225122496bfa79172005c587c2d64bf upstream.
> > 
> > When building an external module, if users don't need to separate the
> > compilation output and source code, they run the following command:
> > "make -C $(LINUX_SRC_DIR) M=$(PWD)". At this point, "$(KBUILD_EXTMOD)"
> > and "$(src)" are the same.
> > 
> > If they need to separate them, they run "make -C $(KERNEL_SRC_DIR)
> > O=$(KERNEL_OUT_DIR) M=$(OUT_DIR) src=$(PWD)". Before running the
> > command, they need to copy "Kbuild" or "Makefile" to "$(OUT_DIR)" to
> > prevent compilation failure.
> > 
> > So the kernel should change the included path to avoid the copy operation.
> > 
> > Signed-off-by: Jing Leng <jleng@ambarella.com>
> > [masahiro: I do not think "M=$(OUT_DIR) src=$(PWD)" is the official way,
> > but this patch is a nice clean up anyway.]
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > [nsc: updated context for v5.4]
> > Signed-off-by: Nicolas Schier <n.schier@avm.de>
> > ---
> >  scripts/Makefile.modpost | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> > index 48585c4d04ad..0273bf7375e2 100644
> > --- a/scripts/Makefile.modpost
> > +++ b/scripts/Makefile.modpost
> > @@ -87,8 +87,7 @@ obj := $(KBUILD_EXTMOD)
> >  src := $(obj)
> >  
> >  # Include the module's Makefile to find KBUILD_EXTRA_SYMBOLS
> > -include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
> > -             $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
> > +include $(if $(wildcard $(src)/Kbuild), $(src)/Kbuild, $(src)/Makefile)
> >  
> >  # modpost option for external modules
> >  MODPOST += -e
> > -- 
> > 2.37.2
> > 
> 
> Does not apply to the 5.4.y tree at all, are you sure you generated this
> properly?

oh, I mixed up something locally.  Thanks for taking the v4.9 version of
it.

Kind regards,
Nicolas
