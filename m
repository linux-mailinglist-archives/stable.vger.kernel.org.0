Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED6414FEC5
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 19:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgBBSfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 13:35:51 -0500
Received: from asavdk3.altibox.net ([109.247.116.14]:35030 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgBBSfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 13:35:50 -0500
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id F094120022;
        Sun,  2 Feb 2020 19:35:46 +0100 (CET)
Date:   Sun, 2 Feb 2020 19:35:45 +0100
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/5] drm: Remove PageReserved manipulation from
 drm_pci_alloc
Message-ID: <20200202183545.GB18495@ravnborg.org>
References: <20200202171635.4039044-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200202171635.4039044-1-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=eMA9ckh1 c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8
        a=e5mUnYsNAAAA:8 a=taGs_qngAAAA:8 a=VwQbUJbxAAAA:8 a=6WBxI-KXEXGNoQ-2y5gA:9
        a=bhQ34oRM2GccxT0d:21 a=5fb4q4EQECoogPcF:21 a=QEXdDO2ut3YA:10
        a=Vxmtnl_E_bksehYqCbjh:22 a=DM_PlaNYpjARcMQr2apF:22
        a=AjGcO6oz07-iQ99wixmX:22 a=pHzHmUro8NiASowvMSCR:22
        a=n87TN5wuljxrRezIQYnT:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris.

On Sun, Feb 02, 2020 at 05:16:31PM +0000, Chris Wilson wrote:
> drm_pci_alloc/drm_pci_free are very thin wrappers around the core dma
> facilities, and we have no special reason within the drm layer to behave
> differently. In particular, since
> 
> commit de09d31dd38a50fdce106c15abd68432eebbd014
> Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Date:   Fri Jan 15 16:51:42 2016 -0800
> 
>     page-flags: define PG_reserved behavior on compound pages
> 
>     As far as I can see there's no users of PG_reserved on compound pages.
>     Let's use PF_NO_COMPOUND here.
> 
> it has been illegal to combine GFP_COMP with SetPageReserved, so lets
> stop doing both and leave the dma layer to its own devices.
> 
> Reported-by: Taketo Kabe
> Closes: https://gitlab.freedesktop.org/drm/intel/issues/1027
> Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v4.5+
> ---
Out of curiosity I added the full series and tried to build it.
I did not really take the time to review the patches.


It failed with alpha allmodconfig like this:
(On top of drm-misc-next as of yesterday)

/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c: In function ‘drm_ati_alloc_pcigart_table’:
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:50:7: error: expected expression before ‘^’ token
   50 |       ^gart_info->bus_addr,
      |       ^
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:48:3: error: too few arguments to function ‘dma_alloc_coherent’
   48 |   dma_alloc_coherent(&dev->pdev->dev,
      |   ^~~~~~~~~~~~~~~~~~
In file included from /home/sam/drm/linux.git/arch/alpha/include/asm/pci.h:8,
                 from /home/sam/drm/linux.git/include/linux/pci.h:1777,
                 from /home/sam/drm/linux.git/include/drm/drm_pci.h:35,
                 from /home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:37:
/home/sam/drm/linux.git/include/linux/dma-mapping.h:641:21: note: declared here
  641 | static inline void *dma_alloc_coherent(struct device *dev, size_t size,
      |                     ^~~~~~~~~~~~~~~~~~
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c: At top level:
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:101:2: error: expected identifier or ‘(’ before ‘return’
  101 |  return 1;
      |  ^~~~~~
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:102:1: error: expected identifier or ‘(’ before ‘}’ token
  102 | }
      | ^
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c: In function ‘drm_ati_pcigart_init’:
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:168:13: warning: assignment to ‘u32 *’ {aka ‘unsigned int *’} from ‘unsigned int’ makes pointer from integer without a cast [-Wint-conversion]
  168 |   page_base = (u32) entry->busaddr[i];
      |             ^
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:176:21: error: invalid operands to binary | (have ‘u32 *’ {aka ‘unsigned int *’} and ‘int’)
  176 |     val = page_base | 0xc;
      |                     ^
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:179:22: error: invalid operands to binary >> (have ‘u32 *’ {aka ‘unsigned int *’} and ‘int’)
  179 |     val = (page_base >> 8) | 0xc;
      |                      ^~
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:183:9: warning: assignment to ‘u32’ {aka ‘unsigned int’} from ‘u32 *’ {aka ‘unsigned int *’} makes integer from pointer without a cast [-Wint-conversion]
  183 |     val = page_base;
      |         ^
/home/sam/drm/linux.git/drivers/gpu/drm/r128/ati_pcigart.c:188:12: warning: dereferencing ‘void *’ pointer
  188 |     address[gart_idx] = cpu_to_le32(val);


I did not try other architectures and did not try to fix it.

When I applied the patches checkpatch was no too happy:

Applying: drm: Remove PageReserved manipulation from drm_pci_alloc
[sam-pci fa4a1146af59] drm: Remove PageReserved manipulation from drm_pci_alloc
 Author: Chris Wilson <chris@chris-wilson.co.uk>
 Date: Sun Feb 2 17:16:31 2020 +0000
 1 file changed, 2 insertions(+), 21 deletions(-)
fa4a1146af59 (HEAD -> sam-pci) drm: Remove PageReserved manipulation from drm_pci_alloc
-:10: ERROR:GIT_COMMIT_ID: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")'
#10: 
commit de09d31dd38a50fdce106c15abd68432eebbd014

-:22: ERROR:BAD_SIGN_OFF: Unrecognized email address: 'Taketo Kabe'
#22: 
Reported-by: Taketo Kabe

[sam-pci b553cf48b548] drm/r128: Wean off drm_pci_alloc
 Author: Chris Wilson <chris@chris-wilson.co.uk>
 Date: Sun Feb 2 17:16:33 2020 +0000
 2 files changed, 17 insertions(+), 17 deletions(-)
b553cf48b548 (HEAD -> sam-pci) drm/r128: Wean off drm_pci_alloc
-:13: WARNING:OBSOLETE: drivers/gpu/drm/r128/ati_pcigart.c is marked as 'obsolete' in the MAINTAINERS hierarchy.  No unnecessary modifications please.

-:16: WARNING:OBSOLETE: drivers/gpu/drm/r128/ati_pcigart.c is marked as 'obsolete' in the MAINTAINERS hierarchy.  No unnecessary modifications please.

-:26: CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis
#26: FILE: drivers/gpu/drm/r128/ati_pcigart.c:49:
+		dma_alloc_coherent(&dev->pdev->dev,
+				  gart_info->table_size,

-:27: CHECK:SPACING: spaces preferred around that '^' (ctx:ExV)
#27: FILE: drivers/gpu/drm/r128/ati_pcigart.c:50:
+				  ^gart_info->bus_addr,
 				  ^

[sam-pci 7e77c3ee282d] drm: Remove exports for drm_pci_alloc/drm_pci_free
 Author: Chris Wilson <chris@chris-wilson.co.uk>
 Date: Sun Feb 2 17:16:35 2020 +0000
 4 files changed, 32 insertions(+), 45 deletions(-)
7e77c3ee282d (HEAD -> sam-pci) drm: Remove exports for drm_pci_alloc/drm_pci_free
-:53: CHECK:LINE_SPACING: Please don't use multiple blank lines
#53: FILE: drivers/gpu/drm/drm_legacy.h:215:

+

-:58: ERROR:POINTER_LOCATION: "foo * bar" should be "foo *bar"
#58: FILE: drivers/gpu/drm/drm_legacy.h:220:
+void drm_legacy_pci_free(struct drm_device *dev, struct drm_dma_handle * dmah);

-:100: ERROR:POINTER_LOCATION: "foo * bar" should be "foo *bar"
#100: FILE: drivers/gpu/drm/drm_pci.c:42:
+drm_legacy_pci_alloc(struct drm_device * dev, size_t size, size_t align)

-:119: ERROR:POINTER_LOCATION: "foo * bar" should be "foo *bar"
#119: FILE: drivers/gpu/drm/drm_pci.c:70:
+void drm_legacy_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)

-:119: ERROR:POINTER_LOCATION: "foo * bar" should be "foo *bar"
#119: FILE: drivers/gpu/drm/drm_pci.c:70:
+void drm_legacy_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)


	Sam
